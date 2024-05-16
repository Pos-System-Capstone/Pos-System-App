// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_detail_report.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal_windows.dart';
import 'package:printing/printing.dart';
import '../data/model/response/sessions.dart';
import '../util/bill-printing.dart';
import 'base_view_model.dart';
import 'menu_view_model.dart';

/// Network Printer
class PrinterViewModel extends BaseViewModel {
  List<Printer>? listDevice = [];
  List<BluetoothInfo> listBluetoothDevices = [];
  String? selectBluetoothDeviceMac;
  Printer? selectedBillPrinter;
  Printer? selectedProductPrinter;
  int paperOptions = 0;
  PrinterDeviceEnum printMode = PrinterDeviceEnum.USB;
  PrinterViewModel() {
    getPaperRoll().then((value) => paperOptions == value);
    if (GetPlatform.isAndroid || GetPlatform.isIOS) {
      scanBluetoothPrinter();
    } else if (GetPlatform.isWindows) {
      scanPrinter();
    }
  }

  void scanPrinter() {
    try {
      Printing.listPrinters().then((value) {
        listDevice = value.where((element) => element.isAvailable).toList();
        Future<String?> billPrinter = getBillPrinter();
        Future<String?> productPrinter = getProductPrinter();
        billPrinter.then((value) {
          if (value != null) {
            for (var element in listDevice!) {
              if (element.url == value) {
                selectedBillPrinter = element;
              }
            }
          }
        });
        productPrinter.then((value) {
          if (value != null) {
            for (var element in listDevice!) {
              if (element.url == value) {
                selectedProductPrinter = element;
              }
            }
          }
        });
      });
      setState(ViewStatus.Completed);
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> scanBluetoothPrinter() async {
    try {
      setState(ViewStatus.Loading);
      listBluetoothDevices = await PrintBluetoothThermal.pairedBluetooths;
      setState(ViewStatus.Completed);
    } catch (e) {
      printError(info: e.toString());
      setState(ViewStatus.Completed);
    }
  }

  void selectBillPrinter(Printer printer) {
    selectedBillPrinter = printer;
    setBillPrinter(printer.url);
    notifyListeners();
  }

  void setPaperOption(String option) {
    paperOptions = int.parse(option);
    setPaperRoll(paperOptions);
    print("Paper rolll $paperOptions");
    notifyListeners();
  }

  Future<void> selectBluetoothPrinter(String mac) async {
    final bool disConnectRes = await PrintBluetoothThermal.disconnect;
    if (disConnectRes) {
      print(disConnectRes);
      final bool result =
          await PrintBluetoothThermal.connect(macPrinterAddress: mac);

      if (result) {
        printMode = PrinterDeviceEnum.BLUETOOTH;
        selectBluetoothDeviceMac = mac;
        setBluetoothPrinter(selectBluetoothDeviceMac ?? '');
        if (kDebugMode) {
          print("state connected $result");
          print("state connected $mac");
          print("PRINT MODE ${printMode.toString()}");
        }
      }
      notifyListeners();
    }
  }

  void selectProductPrinter(Printer printer) {
    selectedProductPrinter = printer;
    setProductPrinter(printer.url);
    notifyListeners();
  }

  void removeBillPrinter() {
    selectedBillPrinter = null;
    deleteBillPrinter();
    notifyListeners();
  }

  Future<void> removeBluetoothPrinter() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    if (status) {
      selectBluetoothDeviceMac = null;
      printMode = PrinterDeviceEnum.USB;
      deleteBluetoothPrinter();
    }
    notifyListeners();
  }

  void removeStampPrinter() {
    selectedProductPrinter = null;
    deleteProductPrinter();
    notifyListeners();
  }

  void testPrinter(Printer printer) {
    Printing.directPrintPdf(
        printer: printer,
        format: paperOptions == 58
            ? PdfPageFormat.roll57
            : paperOptions == 80
                ? PdfPageFormat.roll80
                : PdfPageFormat.undefined,
        onLayout: (PdfPageFormat format) {
          return _generatePdf(format, "Test");
        });
  }

  Future<void> testBluetoothPrinter() async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      bool result = false;
      if (GetPlatform.isWindows) {
        List<int> ticket = await testWindows();
        result = await PrintBluetoothThermalWindows.writeBytes(bytes: ticket);
      } else {
        List<int> ticket = await testTicket();
        result = await PrintBluetoothThermal.writeBytes(ticket);
      }
      print("print test result:  $result");
    } else {
      print("print test conexionStatus: $connectionStatus");
    }
  }

  Future<List<int>> testWindows() async {
    List<int> bytes = [];
    bytes +=
        PostCode.text(text: "Size compressed", fontSize: FontSize.compressed);
    bytes += PostCode.text(text: "Size normal", fontSize: FontSize.normal);
    bytes += PostCode.text(text: "Bold", bold: true);
    bytes += PostCode.text(text: "Inverse", inverse: true);
    bytes += PostCode.text(text: "AlignPos right", align: AlignPos.right);
    bytes += PostCode.text(text: "Size big", fontSize: FontSize.big);
    bytes += PostCode.enter();

    //List of rows
    bytes += PostCode.row(
        texts: ["PRODUCT", "VALUE"],
        proportions: [60, 40],
        fontSize: FontSize.compressed);
    for (int i = 0; i < 3; i++) {
      bytes += PostCode.row(
          texts: ["Item $i", "$i,00"],
          proportions: [60, 40],
          fontSize: FontSize.compressed);
    }

    bytes += PostCode.line();

    bytes += PostCode.barcode(barcodeData: "123456789");
    bytes += PostCode.qr("123456789");

    bytes += PostCode.enter(nEnter: 5);

    return bytes;
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ',
        styles: PosStyles(codeTable: 'CP1252'));
    bytes += generator.text('Special 2: blåbærgrød',
        styles: PosStyles(codeTable: 'CP1252'));

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    //barcode

    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    //QR code
    bytes += generator.qrcode('example.com');

    bytes += generator.text(
      'Text size 50%',
      styles: PosStyles(
        fontType: PosFontType.fontB,
      ),
    );
    bytes += generator.text(
      'Text size 100%',
      styles: PosStyles(
        fontType: PosFontType.fontA,
      ),
    );
    bytes += generator.text(
      'Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );

    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  void testPrinterMobile() {
    Printing.layoutPdf(
        usePrinterSettings: true,
        format: PdfPageFormat.roll57,
        onLayout: (PdfPageFormat format) {
          return _generatePdf(format, "test");
        });
  }

  Future<void> printBill(
      OrderResponseModel orderResponse, String paymentName) async {
    if (GetPlatform.isWeb || GetPlatform.isMobile) {
      await Printing.layoutPdf(
          format: PdfPageFormat.undefined,
          onLayout: (PdfPageFormat format) {
            return generateBillInvoice(format, orderResponse, paymentName);
          });
      return;
    }
    if (selectedBillPrinter == null) {
      return;
    } else {
      await Printing.directPrintPdf(
          printer: selectedBillPrinter!,
          format: paperOptions == 58
              ? PdfPageFormat.roll57
              : paperOptions == 80
                  ? PdfPageFormat.roll80
                  : PdfPageFormat.undefined,
          onLayout: (PdfPageFormat format) {
            return generateBillInvoice(format, orderResponse, paymentName);
          });

      await Printing.directPrintPdf(
          printer: selectedBillPrinter!,
          format: paperOptions == 58
              ? PdfPageFormat.roll57
              : paperOptions == 80
                  ? PdfPageFormat.roll80
                  : PdfPageFormat.undefined,
          onLayout: (PdfPageFormat format) {
            return generateBillInvoice(format, orderResponse, paymentName);
          });
    }
    if (selectedProductPrinter == null) {
      return;
    } else {
      if (orderResponse.productList != null) {
        await Printing.directPrintPdf(
            printer: selectedBillPrinter!,
            format: paperOptions == 58
                ? PdfPageFormat.roll57
                : paperOptions == 80
                    ? PdfPageFormat.roll80
                    : PdfPageFormat.undefined,
            onLayout: (PdfPageFormat format) {
              return generateKitchenInvoice(format, orderResponse);
            });
      }
    }
  }

  Future<void> printBillDraft(OrderResponseModel orderResponse) async {
    if (GetPlatform.isWeb || GetPlatform.isMobile) {
      await Printing.layoutPdf(
          format: paperOptions == 58
              ? PdfPageFormat.roll57
              : paperOptions == 80
                  ? PdfPageFormat.roll80
                  : PdfPageFormat.undefined,
          onLayout: (PdfPageFormat format) {
            return generateDraftBill(format, orderResponse);
          });

      return;
    }
    if (selectedBillPrinter == null) {
      return;
    } else {
      await Printing.directPrintPdf(
          printer: selectedBillPrinter!,
          format: paperOptions == 58
              ? PdfPageFormat.roll57
              : paperOptions == 80
                  ? PdfPageFormat.roll80
                  : PdfPageFormat.undefined,
          onLayout: (PdfPageFormat format) {
            return generateDraftBill(format, orderResponse);
          });
    }
    if (selectedProductPrinter == null) {
      return;
    } else {
      if (orderResponse.productList != null) {
        await Printing.directPrintPdf(
            printer: selectedBillPrinter!,
            format: paperOptions == 58
                ? PdfPageFormat.roll57
                : paperOptions == 80
                    ? PdfPageFormat.roll80
                    : PdfPageFormat.undefined,
            onLayout: (PdfPageFormat format) {
              return generateKitchenInvoice(
                format,
                orderResponse,
              );
            });
      }
    }
  }

  Future<void> printBillMobile(
      OrderResponseModel orderResponse, String paymentName) async {
    await Printing.layoutPdf(
        format: paperOptions == 58
            ? PdfPageFormat.roll57
            : paperOptions == 80
                ? PdfPageFormat.roll80
                : PdfPageFormat.undefined,
        onLayout: (PdfPageFormat format) async =>
            generateBillInvoice(format, orderResponse, paymentName));
    if (orderResponse.productList != null) {
      for (var product in orderResponse.productList!) {
        for (var i = 1; i <= product.quantity!; i++) {
          await Printing.layoutPdf(
              format: PdfPageFormat(32 * PdfPageFormat.mm, double.infinity,
                  marginAll: 2 * PdfPageFormat.mm),
              onLayout: (PdfPageFormat format) {
                return generateStampInvoice(
                    format,
                    product,
                    orderResponse.checkInDate,
                    orderResponse.invoiceId,
                    orderResponse.customerNumber);
              });
        }
      }
    }
  }

  void printCloseSessionInvoice(Session session, SessionDetailReport report,
      StoreModel storeModel, Account account) {
    Printing.directPrintPdf(
        printer: selectedBillPrinter!,
        // format: PdfPageFormat(58 * PdfPageFormat.mm, double.infinity,
        //     marginAll: 2 * PdfPageFormat.mm),
        format: paperOptions == 58
            ? PdfPageFormat.roll57
            : paperOptions == 80
                ? PdfPageFormat.roll80
                : PdfPageFormat.undefined,
        onLayout: (PdfPageFormat format) {
          return generateClostSessionInvoice(
              format, session, report, storeModel, account);
        });
  }

  void printEndDayStoreReport(DayReport report, String title) {
    // Printing.directPrintPdf(
    //     printer: selectedBillPrinter!,
    //     // format: PdfPageFormat(58 * PdfPageFormat.mm, double.infinity,
    //     //     marginAll: 2 * PdfPageFormat.mm),
    //     format: PdfPageFormat.roll80,
    //     onLayout: (PdfPageFormat format) {
    //       return generateEndDayReport(format, report);
    //     });
    Get.dialog(Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PdfPreview(
        build: (PdfPageFormat format) =>
            generateEndDayReport(format, report, title),
      ),
    ));
  }

  void printQRCode(String url) {
    Printing.directPrintPdf(
        printer: selectedBillPrinter!,
        format: paperOptions == 58
            ? PdfPageFormat.roll57
            : paperOptions == 80
                ? PdfPageFormat.roll80
                : PdfPageFormat.undefined,
        onLayout: (PdfPageFormat format) {
          return genQRcode(format, url);
        });
  }

  bool isBillPrinterConnected(
    Printer printer,
  ) {
    if (printer == selectedBillPrinter) {
      return true;
    } else {
      return false;
    }
  }

  bool isBluetoothPrinterConnected(
    String mac,
  ) {
    if (kDebugMode) {
      print(selectBluetoothDeviceMac);
    }
    if (mac == (selectBluetoothDeviceMac ?? '')) {
      return true;
    } else {
      return false;
    }
  }

  bool isStampPrinterConnected(Printer printer) {
    if (printer == selectedProductPrinter) {
      return true;
    } else {
      return false;
    }
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.interBold();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text(title, style: pw.TextStyle(font: font)),
                ),
              ),
              pw.SizedBox(height: 20),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

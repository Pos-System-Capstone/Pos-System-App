// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_detail_report.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/helper/qr_generate.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';
import 'package:printing/printing.dart';
import '../data/model/account.dart';
import '../data/model/response/sessions.dart';
import '../util/bill-printing.dart';
import 'base_view_model.dart';

/// Network Printer
class PrinterViewModel extends BaseViewModel {
  List<Printer>? listDevice = [];
  Printer? selectedBillPrinter;
  Printer? selectedProductPrinter;
  PrinterViewModel() {
    scanPrinter();
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

  void selectBillPrinter(Printer printer) {
    selectedBillPrinter = printer;
    setBillPrinter(printer.url);
    notifyListeners();
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

  void removeStampPrinter() {
    selectedProductPrinter = null;
    deleteProductPrinter();
    notifyListeners();
  }

  void testPrinter(Printer printer) {
    Printing.directPrintPdf(
        printer: printer,
        format: PdfPageFormat.roll57,
        onLayout: (PdfPageFormat format) {
          return _generatePdf(format, "Test");
        });
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
      OrderResponseModel orderResponse, int table, String paymentName) async {
    if (selectedBillPrinter == null) {
      return;
    } else {
      await Printing.directPrintPdf(
          printer: selectedBillPrinter!,
          format: PdfPageFormat.roll80,
          onLayout: (PdfPageFormat format) {
            return generateBillInvoice(
                format, orderResponse, table, paymentName);
          });
    }
    if (selectedProductPrinter == null) {
      return;
    } else {
      if (orderResponse.productList != null) {
        await Printing.directPrintPdf(
            printer: selectedBillPrinter!,
            format: PdfPageFormat.roll80,
            onLayout: (PdfPageFormat format) {
              return generateKitchenInvoice(
                format,
                orderResponse,
                table,
                paymentName,
              );
            });
      }
    }
  }

  Future<void> printBillMobile(
      OrderResponseModel orderResponse, int table, String paymentName) async {
    await Printing.layoutPdf(
        format: PdfPageFormat.roll80,
        onLayout: (PdfPageFormat format) async =>
            generateBillInvoice(format, orderResponse, table, paymentName));
    if (orderResponse.productList != null) {
      for (var product in orderResponse.productList!) {
        for (var i = 1; i <= product.quantity!; i++) {
          await Printing.layoutPdf(
              format: PdfPageFormat(32 * PdfPageFormat.mm, double.infinity,
                  marginAll: 2 * PdfPageFormat.mm),
              onLayout: (PdfPageFormat format) {
                return generateStampInvoice(format, product,
                    orderResponse.checkInDate, orderResponse.invoiceId, table);
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
        format: PdfPageFormat.roll80,
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
        format: PdfPageFormat.roll80,
        onLayout: (PdfPageFormat format) {
          return genQRcode(format, url);
        });
  }

  bool isBillPrinterConnected(Printer printer) {
    if (printer == selectedBillPrinter) {
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

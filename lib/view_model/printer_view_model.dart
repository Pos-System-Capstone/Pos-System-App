/*
 * esc_pos_printer
 * Created by Andrey Ushakov
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:async';
import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:network_tools/network_tools.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:printing/printing.dart';
import '../util/bill-printing.dart';
import '../widgets/Dialogs/other_dialogs/dialog.dart';
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
        print(listDevice);
        Future<String?> billPrinter = getBillPrinter();
        Future<String?> productPrinter = getProductPrinter();
        billPrinter.then((value) {
          if (value != null) {
            listDevice!.forEach((element) {
              if (element.url == value) {
                selectedBillPrinter = element;
              }
            });
          }
        });
        productPrinter.then((value) {
          if (value != null) {
            listDevice!.forEach((element) {
              if (element.url == value) {
                selectedProductPrinter = element;
              }
            });
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

  void deleteBillPrinter() {
    selectedBillPrinter = null;
    deleteBillPrinter();
    notifyListeners();
  }

  void deleteProductPrinter() {
    selectedProductPrinter = null;
    deleteProductPrinter();
    notifyListeners();
  }

  void testPrinter(Printer printer) {
    Printing.directPrintPdf(
        printer: printer,
        format: PdfPageFormat.roll57,
        onLayout: (PdfPageFormat format) {
          return _generatePdf(format, "test");
        });
  }

  void printBill(OrderResponseModel orderResponse, int table) {
    Printing.directPrintPdf(
        printer: selectedBillPrinter!,
        // format: PdfPageFormat(58 * PdfPageFormat.mm, double.infinity,
        //     marginAll: 2 * PdfPageFormat.mm),
        format: PdfPageFormat.roll80,
        onLayout: (PdfPageFormat format) {
          return generateBillInvoice(format, orderResponse, table);
        });
    if (orderResponse.productList != null) {
      for (var product in orderResponse.productList!) {
        for (var i = 1; i <= product.quantity!; i++) {
          Printing.directPrintPdf(
              printer: selectedProductPrinter!,
              format: PdfPageFormat(32 * PdfPageFormat.mm, double.infinity,
                  marginAll: 2 * PdfPageFormat.mm),
              onLayout: (PdfPageFormat format) {
                return generateStampInvoice(format, product,
                    orderResponse.checkInDate, orderResponse.invoiceId);
              });
        }
      }
    }
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
    final font = await PdfGoogleFonts.inconsolataRegular();

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
              pw.Flexible(child: pw.FlutterLogo())
            ],
          );
        },
      ),
    );

    return pdf.save();
  }
}

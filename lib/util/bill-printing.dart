import 'dart:typed_data' show Uint8List;
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/util/format.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:tiengviet/tiengviet.dart';

Future<Uint8List> generateBillInvoice(
    PdfPageFormat format, OrderResponseModel order) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interMedium();
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
              children: [
                pw.Text("DEER COFFEE",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 14)),
                pw.SizedBox(height: 16),
                pw.Text("S202 Vinhome GrandPark, TP Thu Duc, HCM",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text("SDT: 1234567890",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.SizedBox(height: 16),
                pw.FittedBox(
                  child: pw.Text("HOA DON BAN HANG",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: font, fontSize: 12)),
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Ma Don:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                    pw.Text(TiengViet.parse(order.invoiceId.toString()),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Thoi gian:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                    pw.Text(
                        formatTime(
                            order.checkInDate ?? DateTime.now().toString()),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text("Ten mon:",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("SL:",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("Tong:",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                  ],
                )
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

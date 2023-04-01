import 'dart:typed_data' show Uint8List;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:tiengviet/tiengviet.dart';

Future<Uint8List> generateBillInvoice(
    PdfPageFormat format, OrderResponseModel order, int table) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interBold();

  StoreModel storeInfo = Get.find<MenuViewModel>().storeDetails;
  final provider =
      await flutterImageProvider(NetworkImage(storeInfo!.brandPicUrl!));

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Image(
                    provider,
                    width: 160,
                    height: 160,
                  ),
                ),
                pw.Text(storeInfo.name ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                pw.Text(storeInfo.address ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("Hotline: ${storeInfo.phone ?? ""}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("Email: ${storeInfo.email ?? ""}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.SizedBox(height: 16),
                pw.FittedBox(
                  child: pw.Text("HÓA ĐƠN THANH TOÁN",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: font, fontSize: 12)),
                ),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Mã đơn:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(order.invoiceId ?? "",
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Ngày:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(
                        formatTime(
                            order.checkInDate ?? DateTime.now().toString()),
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Bàn: $table",
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 0.5,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text("Tên món",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 8)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("SL",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 8)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("Tổng",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: font, fontSize: 8)),
                    ),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                for (ProductList item in order.productList!)
                  pw.Column(children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          flex: 6,
                          child: pw.Text(item.name ?? '',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font, fontSize: 8)),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(item.quantity.toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font, fontSize: 8)),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(formatPrice(item.finalAmount ?? 0),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: font, fontSize: 8)),
                        ),
                      ],
                    ),
                    if (item.extras != null)
                      for (Extras extra in item.extras!)
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              flex: 7,
                              child: pw.Text("+${extra.name}",
                                  textAlign: pw.TextAlign.left,
                                  style: pw.TextStyle(font: font, fontSize: 8)),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                  formatPrice(extra.finalAmount ?? 0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: font, fontSize: 8)),
                            ),
                          ],
                        ),
                    pw.Text(item.note ?? '',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.SizedBox(height: 8),
                  ]),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Tổng cộng:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 10)),
                    pw.Text(formatPrice(order.totalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 10)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Giảm giá:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 9)),
                    pw.Text(formatPrice(order.discount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Phương thức :",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 9)),
                    pw.Text(order.payment!.name ?? '',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 0.5,
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Thanh toán:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(formatPrice(order.finalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.SizedBox(height: 16),
                pw.Text("Xin cảm ơn và hẹn gặp lại",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("Wifi: DeerCoffe  Pass: 12345678",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    "Biên lai tính tiền có giá trị xuất hóa đơn GTGT trong ngày",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    "Hóa đơn đã bao gồm thuế GTGT  ${percentCalculation(order.vat ?? 0)})",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.SizedBox(height: 16),
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

Future<Uint8List> generateStampInvoice(PdfPageFormat format,
    ProductList product, String? time, String? invoiceId) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interBold();
  pdf.addPage(pw.Page(
      pageFormat: format,
      orientation: pw.PageOrientation.natural,
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(invoiceId ?? '',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Text(formatTime(time ?? DateTime.now().toString()),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Divider(
                thickness: 1,
              ),
              pw.Text(product.name ?? '',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              if (product.extras != null)
                for (Extras extra in product.extras!)
                  pw.Text(" +${extra.name}",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
              pw.SizedBox(height: 4),
              pw.Text(product.note ?? '',
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(font: font, fontSize: 8)),
            ]);
      }));
  return pdf.save();
}

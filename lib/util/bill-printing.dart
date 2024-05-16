// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:typed_data' show Uint8List;
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_detail_report.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../data/model/account.dart';
import '../data/model/response/sessions.dart';

Future<Uint8List> genQRcode(PdfPageFormat format, String imageURL) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interMedium();
  final image = await flutterImageProvider(NetworkImage(imageURL));
  pdf.addPage(pw.Page(
      pageFormat: format,
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text("Scan QR code để thanh toán",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Image(
                image,
              ),
            ]);
      }));

  return pdf.save();
}

Future<Uint8List> generateBillInvoice(
    PdfPageFormat format, OrderResponseModel order, String payment) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();

  StoreModel storeInfo = Get.find<MenuViewModel>().storeDetails;

  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(storeInfo.name ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("SDT:${storeInfo.phone ?? ""}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text(storeInfo.address ?? "",
                    textAlign: pw.TextAlign.center,
                    maxLines: 2,
                    overflow: pw.TextOverflow.clip,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.SizedBox(height: 4),
                pw.FittedBox(
                  child: pw.Text("HOÁ ĐƠN THANH TOÁN",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: font, fontSize: 10)),
                ),
                pw.SizedBox(height: 4),
                pw.Text(order.invoiceId ?? "",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    "Ngày: ${formatTime(order.checkInDate ?? DateTime.now().toString())}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("STT: ${order.customerNumber ?? 1}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text("Tên món",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("SL",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("Tổng",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: font, fontSize: 7)),
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
                              style: pw.TextStyle(font: font, fontSize: 7)),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(item.quantity.toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font, fontSize: 7)),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(formatPrice(item.finalAmount ?? 0),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: font, fontSize: 7)),
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
                                  style: pw.TextStyle(font: font, fontSize: 7)),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                  formatPrice(extra.finalAmount ?? 0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: font, fontSize: 7)),
                            ),
                          ],
                        ),
                    pw.Text(item.note ?? '',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
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
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(formatPrice(order.totalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                if (order.promotionList != null || order.productList != [])
                  for (PromotionList promotion in order.promotionList!)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("${promotion.promotionName}",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(font: font, fontSize: 7)),
                        pw.Text(
                            promotion.effectType == "GET_POINT"
                                ? ("+${promotion.discountAmount} Điểm")
                                : ("- ${formatPrice(promotion.discountAmount ?? 0)}"),
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(font: font, fontSize: 7)),
                      ],
                    ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tổng giảm giá',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                    pw.Text(formatPrice(order.discount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Nhận món :",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(
                        showOrderType(order.orderType ?? DeliType().eatIn.type)
                                .label ??
                            '',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Phương thức :",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(payment,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Thanh toán:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(formatPrice(order.finalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.Text("Xin cảm ơn và hẹn gặp lại",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text('Wifi: ${storeInfo.wifiName}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text('Pass: ${storeInfo.wifiPassword}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

Future<Uint8List> generateDraftBill(
    PdfPageFormat format, OrderResponseModel order) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();

  StoreModel storeInfo = Get.find<MenuViewModel>().storeDetails;
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(storeInfo.name ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("SDT:${storeInfo.phone ?? ""}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text(storeInfo.address ?? "",
                    textAlign: pw.TextAlign.center,
                    maxLines: 2,
                    overflow: pw.TextOverflow.clip,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.SizedBox(height: 4),
                pw.FittedBox(
                  child: pw.Text("HOÁ ĐƠN TẠM TÍNH",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: font, fontSize: 10)),
                ),
                pw.SizedBox(height: 4),
                pw.Text(order.invoiceId ?? "",
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text(
                    "Ngày: ${formatTime(order.checkInDate ?? DateTime.now().toString())}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Text("STT: ${order.customerNumber ?? 1}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text("Tên món",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("SL",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 7)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("Tổng",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: font, fontSize: 7)),
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
                              style: pw.TextStyle(font: font, fontSize: 7)),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(item.quantity.toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font, fontSize: 7)),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(formatPrice(item.finalAmount ?? 0),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: font, fontSize: 7)),
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
                                  style: pw.TextStyle(font: font, fontSize: 7)),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                  formatPrice(extra.finalAmount ?? 0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: font, fontSize: 7)),
                            ),
                          ],
                        ),
                    pw.Text(item.note ?? '',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
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
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(formatPrice(order.totalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                if (order.promotionList != null || order.productList != [])
                  for (PromotionList promotion in order.promotionList!)
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("${promotion.promotionName}",
                            textAlign: pw.TextAlign.left,
                            style: pw.TextStyle(font: font, fontSize: 7)),
                        pw.Text(
                            promotion.effectType == "GET_POINT"
                                ? ("+${promotion.discountAmount} Điểm")
                                : ("- ${formatPrice(promotion.discountAmount ?? 0)}"),
                            textAlign: pw.TextAlign.right,
                            style: pw.TextStyle(font: font, fontSize: 7)),
                      ],
                    ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tổng giảm giá',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                    pw.Text(formatPrice(order.discount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Nhận món :",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(
                        showOrderType(order.orderType ?? DeliType().eatIn.type)
                                .label ??
                            '',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Thanh toán:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(formatPrice(order.finalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 9,
                            fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Ghi chú:",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text(order.notes ?? '',
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ],
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 1,
                ),
                pw.Text("Xin cảm ơn và hẹn gặp lại",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text('Wifi: ${storeInfo.wifiName}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
                pw.Text('Pass: ${storeInfo.wifiPassword}',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

Future<Uint8List> generateKitchenInvoice(
    PdfPageFormat format, OrderResponseModel order) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (context) {
        return pw.SizedBox(
            width: double.infinity,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(order.invoiceId ?? "",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 9)),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("STT: ${order.customerNumber ?? 1}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: font, fontSize: 12)),
                    pw.Text(showOrderType(order.orderType ?? "EAT_IN").label,
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 12)),
                  ],
                ),
                pw.Text(
                    "Ngày: ${formatTime(order.checkInDate ?? DateTime.now().toString())}",
                    textAlign: pw.TextAlign.left,
                    style: pw.TextStyle(font: font, fontSize: 8)),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      flex: 6,
                      child: pw.Text("Tên món",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 9)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("SL",
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(font: font, fontSize: 9)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("Tổng",
                          textAlign: pw.TextAlign.right,
                          style: pw.TextStyle(font: font, fontSize: 9)),
                    ),
                  ],
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
                              style: pw.TextStyle(font: font, fontSize: 9)),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(item.quantity.toString(),
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(font: font, fontSize: 9)),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text(formatPrice(item.finalAmount ?? 0),
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(font: font, fontSize: 9)),
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
                                  style: pw.TextStyle(font: font, fontSize: 9)),
                            ),
                            pw.Expanded(
                              flex: 2,
                              child: pw.Text(
                                  formatPrice(extra.finalAmount ?? 0),
                                  textAlign: pw.TextAlign.right,
                                  style: pw.TextStyle(font: font, fontSize: 9)),
                            ),
                          ],
                        ),
                    pw.Text(item.note ?? '',
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 9)),
                  ]),
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

Future<Uint8List> generateStampInvoice(
  PdfPageFormat format,
  ProductList product,
  String? time,
  String? invoiceId,
  num? table,
) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();
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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("STT: ${table ?? 1}",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(formatTime(time ?? DateTime.now().toString()),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
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

Future<Uint8List> generateClostSessionInvoice(
    PdfPageFormat format,
    Session session,
    SessionDetailReport report,
    StoreModel store,
    Account account) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();

  pdf.addPage(pw.Page(
      pageFormat: format,
      orientation: pw.PageOrientation.natural,
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text(store.name ?? '',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Text(store.address ?? '',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 7)),
              pw.Text("Vào lúc:${formatTime(DateTime.now().toString())}",
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(font: font, fontSize: 7)),
              pw.Text("BIÊN BẢN GIAO CA",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 8)),
              pw.Divider(
                thickness: 1,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tên ca:",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(session.name ?? '',
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Nhân viên:",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text(account.name,
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 7,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(
                thickness: 1,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Nội dung tóm tắt:",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Text("Giá trị",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(
                          font: font,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Divider(
                thickness: 1,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Giờ vào ca:",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatTime(session.startDateTime ?? ''),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Giờ kết ca:",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatTime(session.endDateTime ?? ''),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn hàng",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalOrder.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn tiền mặt",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalCash.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu tiền mặt",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.cashAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn ngân hàng",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalBanking.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu ngân hàng",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.bankingAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn momo",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalMomo.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu momo",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.momoAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn GrabFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalGrabFood.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu GrabFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.grabFoodAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn ShopeeFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalShopeeFood.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu ShopeeFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.shopeeFoodAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn BeFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalBeFood.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu BeFood",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.beFoodAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn Visa",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalCash.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu Visa",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.visaAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Số đơn Thẻ thành viên",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(report.totalPointify.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu Thẻ thành viên",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.pointifyAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu trước giảm",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.totalAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Giảm giá",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.totalDiscount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu sau giảm",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(report.finalAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Divider(
                thickness: 1,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Ghi chú",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text("....................",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Divider(
                thickness: 1,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Nhân viên",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text("Quản lý",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Ký tên",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text("Ký tên",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 40),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 40),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("..............",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("..............",
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
              ),
            ]);
      }));
  return pdf.save();
}

Future<Uint8List> generateQRCode(
  PdfPageFormat format,
  String? code,
  String? paymentMethod,
) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();
  pdf.addPage(pw.Page(
      pageFormat: format,
      orientation: pw.PageOrientation.natural,
      build: (pw.Context context) {
        return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(paymentMethod ?? '',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: font, fontSize: 10)),
              pw.SizedBox(height: 10),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: code ?? '',
                width: 200,
                height: 200,
              ),
            ]);
      }));
  return pdf.save();
}

Future<Uint8List> generateEndDayReport(
  PdfPageFormat format,
  DayReport reportDetails,
  String? title,
) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interLight();
  Account? account;
  getUserInfo().then((value) => account = value);
  pdf.addPage(pw.Page(
      pageFormat: format,
      orientation: pw.PageOrientation.natural,
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  title ?? '',
                  style: pw.TextStyle(
                      font: font, fontSize: 10, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 8),
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Text(
                        "Nguời lập phiếu: ${account?.name ?? "Staff"}",
                        style: pw.TextStyle(font: font, fontSize: 8),
                      ),
                      pw.Spacer(),
                      pw.Text(
                        "Ngày lập phiếu: ${formatOnlyDate(DateTime.now().toIso8601String())}",
                        style: pw.TextStyle(font: font, fontSize: 8),
                      ),
                    ]),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Expanded(
                      flex: 7,
                      child: pw.Text(
                        'Tên',
                        style: pw.TextStyle(font: font, fontSize: 7),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'SL',
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: font, fontSize: 7),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Align(
                        alignment: pw.Alignment.centerRight,
                        child: pw.Text(
                          'Tổng',
                          style: pw.TextStyle(font: font, fontSize: 7),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // pw.ListView.builder(
            //   itemCount: reportDetails.categoryReports!.length,
            //   itemBuilder: (context, i) {
            //     return reportDetails.categoryReports![i].totalProduct == 0
            //         ? pw.SizedBox()
            //         : categoryReportItem(
            //             reportDetails.categoryReports![i], font);
            //   },
            // ),
            pw.Divider(thickness: 0.5),
            pw.Text(
              'Doanh thu bán hàng',
              style: pw.TextStyle(font: font, fontSize: 8),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu trước giảm giá (1)',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.totalAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Giảm giá (2)',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.totalDiscount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu sau giảm giá (3)=(1)-(2)',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.finalAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Text(
              'Hình thức mua hàng',
              style: pw.TextStyle(font: font, fontSize: 7),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn tại quán',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalOrderInStore ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn mang đi',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalOrderTakeAway ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn giao hàng',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalOrderDeli ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Tại quán',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.inStoreAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Mang đi',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.takeAwayAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Giao hàng',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.deliAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Text(
              'Hình thức thanh toán',
              style: pw.TextStyle(font: font, fontSize: 8),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn tiền mặt',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalCash ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn chyển khoản',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalBanking ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn Momo',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalMomo ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Đơn Visa',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalVisa ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Tiền mặt',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.cashAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Chuyển khoản',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.bankingAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Momo',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.momoAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Doanh thu Visa',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.visaAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),

            pw.Text(
              'Đơn hàng',
              style: pw.TextStyle(font: font, fontSize: 7),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Tổng số sản phẩm',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalProduct ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Tổng số đơn hoàn thành(6)',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalOrder ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
          ],
        );
      }));
  return pdf.save();
}

Future<List<int>> generateBluetoothInvoice(
    OrderResponseModel order, String payment, StoreModel storeInfo) async {
  List<int> bytes = [];
  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  bytes += generator.setGlobalFont(PosFontType.fontB);

  bytes += generator.setGlobalCodeTable('CP1252');
  bytes += generator.setStyles(
      PosStyles(
        codeTable: 'CP1252',
        align: PosAlign.center,
        fontType: PosFontType.fontB,
      ),
      isKanji: true);
  bytes += generator.text(
    storeInfo.name ?? '',
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      bold: true,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    storeInfo.address ?? '',
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    "HOÁ ĐƠN THANH TOÁN",
    styles: PosStyles(codeTable: 'CP1252', align: PosAlign.center, bold: true),
  );
  bytes += generator.text(
    order.invoiceId ?? '',
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    formatTime(order.checkInDate ?? ''),
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    "STT: ${order.customerNumber ?? 1}",
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.row([
    PosColumn(
      text: 'Tên món',
      width: 6,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: 'SL',
      width: 2,
      styles: PosStyles(align: PosAlign.right),
    ),
    PosColumn(
      text: 'Tổng',
      width: 3,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);
  for (ProductList item in order.productList!) {
    bytes += generator.row([
      PosColumn(
        text: item.name ?? '',
        width: 6,
        styles: PosStyles(align: PosAlign.left),
      ),
      PosColumn(
        text: item.quantity.toString(),
        width: 2,
        styles: PosStyles(align: PosAlign.right),
      ),
      PosColumn(
        text: formatPrice(item.finalAmount ?? 0),
        width: 3,
        styles: PosStyles(align: PosAlign.right),
      ),
    ]);
    if (item.extras != null) {
      for (Extras extra in item.extras!) {
        bytes += generator.row([
          PosColumn(
            text: "+${extra.name}",
            width: 6,
            styles: PosStyles(align: PosAlign.left),
          ),
          PosColumn(
            text: formatPrice(extra.finalAmount ?? 0),
            width: 3,
            styles: PosStyles(align: PosAlign.right),
          ),
        ]);
      }
    }
  }
  bytes += generator.row([
    PosColumn(
      text: 'Tổng cộng:',
      width: 4,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: formatPrice(order.totalAmount ?? 0),
      width: 6,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);
  if (order.promotionList != null || order.productList != []) {
    for (PromotionList promotion in order.promotionList!) {
      bytes += generator.row([
        PosColumn(
          text: "${promotion.promotionName}",
          width: 6,
          styles: PosStyles(align: PosAlign.left),
        ),
        PosColumn(
          text: formatPrice(promotion.discountAmount ?? 0),
          width: 3,
          styles: PosStyles(align: PosAlign.right),
        ),
      ]);
    }
  }
  bytes += generator.row([
    PosColumn(
      text: 'Giảm giá',
      width: 4,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: formatPrice(order.discount ?? 0),
      width: 6,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);
  bytes += generator.row([
    PosColumn(
      text: "Nhận món",
      width: 3,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: showOrderType(order.orderType ?? DeliType().eatIn.type).label ?? '',
      width: 6,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);
  bytes += generator.row([
    PosColumn(
      text: "Thanh toán",
      width: 3,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: formatPrice(order.finalAmount ?? 0),
      width: 6,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);
  bytes += generator.row([
    PosColumn(
      text: "Ghi chú",
      width: 3,
      styles: PosStyles(align: PosAlign.left),
    ),
    PosColumn(
      text: order.notes ?? '',
      width: 6,
      styles: PosStyles(align: PosAlign.right),
    ),
  ]);

  bytes += generator.text(
    "Xin cảm ơn và hẹn gặp lại",
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    "Wifi: ${storeInfo.wifiName}",
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.text(
    "Pass: ${storeInfo.wifiPassword}",
    styles: PosStyles(
      codeTable: 'CP1252',
      align: PosAlign.center,
      fontType: PosFontType.fontB,
    ),
  );
  bytes += generator.feed(2);
  //bytes += generator.cut();
  return bytes;
}

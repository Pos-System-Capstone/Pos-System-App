// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:typed_data' show Uint8List;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import '../data/model/account.dart';

Future<Uint8List> generateBillInvoice(PdfPageFormat format,
    OrderResponseModel order, int table, String payment) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interMedium();

  String deliType = Get.find<OrderViewModel>().deliveryType;
  StoreModel storeInfo = Get.find<MenuViewModel>().storeDetails;
  final provider =
      await flutterImageProvider(NetworkImage(storeInfo.brandPicUrl!));

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
                pw.Row(children: [
                  pw.Image(
                    provider,
                    width: 80,
                    height: 80,
                  ),
                  pw.Column(children: [
                    pw.Text(storeInfo.address ?? "",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                    pw.Text("Hotline:${storeInfo.phone ?? ""}",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(font: font, fontSize: 7)),
                  ]),
                ]),
                pw.FittedBox(
                  child: pw.Text("HÓA ĐƠN THANH TOÁN",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(font: font, fontSize: 11)),
                ),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Text(order.invoiceId ?? "",
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        "Ngày: ${formatTime(order.checkInDate ?? DateTime.now().toString())}",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                    pw.Text("Bàn: $table",
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(font: font, fontSize: 8)),
                  ],
                ),
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
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Giảm giá:",
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
                    pw.Text(showOrderType(deliType).label ?? '',
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
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold)),
                    pw.Text(formatPrice(order.finalAmount ?? 0),
                        textAlign: pw.TextAlign.right,
                        style: pw.TextStyle(
                            font: font,
                            fontSize: 10,
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
                pw.Text("Wifi: Deer Coffee  Pass: 12345678",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(font: font, fontSize: 7)),
              ],
            ));
      },
    ),
  );

  return pdf.save();
}

Future<Uint8List> generateKitchenInvoice(PdfPageFormat format,
    OrderResponseModel order, int table, String payment) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interMedium();
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
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        "Ngày: ${formatTime(order.checkInDate ?? DateTime.now().toString())}",
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
  int table,
) async {
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
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Bàn: $table",
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

Future<Uint8List> generateClostSessionInvoice(PdfPageFormat format,
    SessionDetails session, StoreModel store, Account account) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await PdfGoogleFonts.interBold();

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
                  pw.Text(session.numberOfOrders.toString(),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Doanh thu",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(session.totalAmount ?? 0),
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
                  pw.Text(formatPrice(session.totalDiscountAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Khuyến mãi",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(session.totalPromotion ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tổng",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(session.profitAmount ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tiền mặt trong két",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(session.currentCashInVault ?? 0),
                      textAlign: pw.TextAlign.right,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Tiền mặt đầu ca",
                      textAlign: pw.TextAlign.left,
                      style: pw.TextStyle(font: font, fontSize: 8)),
                  pw.Text(formatPrice(session.initCashInVault ?? 0),
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
  final font = await PdfGoogleFonts.interBold();
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
  StoreEndDayReport reportDetails,
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
                      flex: 8,
                      child: pw.Text(
                        'Tên',
                        style: pw.TextStyle(font: font, fontSize: 7),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'SL',
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
            pw.ListView.builder(
              itemCount: reportDetails.categoryReports!.length,
              itemBuilder: (context, i) {
                return categoryReportItem(
                    reportDetails.categoryReports![i], font);
              },
            ),
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
                  'Doanh thu sau giảm giá(3)=(1)-(2)',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.finalAmount ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Tổng thuế VAT',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.vatAmount ?? 0),
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
                  'Tại quán',
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
                  'Mang đi',
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
                  'Giao hàng',
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
              style: pw.TextStyle(font: font, fontSize: 7),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Tiền mặt',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.finalAmount ?? 0),
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
                  'Tổng số đơn hoàn thành',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  "${reportDetails.totalOrder ?? 0}",
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
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
                  'Đơn mang về',
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
                  'Binh quân hoá đơn',
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
                pw.Text(
                  formatPrice(reportDetails.averageBill ?? 0),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ],
            ),
          ],
        );
      }));
  return pdf.save();
}

pw.Widget categoryReportItem(CategoryReports item, pw.Font font) {
  return pw.Padding(
    padding: pw.EdgeInsets.fromLTRB(4, 0, 4, 0),
    child: pw.Column(
      children: [
        pw.Divider(thickness: 0.5, borderStyle: pw.BorderStyle.dashed),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 7,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    item.name!,
                    style: pw.TextStyle(
                        font: font,
                        fontSize: 8,
                        fontWeight: pw.FontWeight.bold),
                    maxLines: 2,
                    overflow: pw.TextOverflow.clip,
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    "${item.totalProduct}",
                    style: pw.TextStyle(font: font, fontSize: 7),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              flex: 3,
              child: pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  formatPrice(item.totalAmount!),
                  style: pw.TextStyle(font: font, fontSize: 7),
                ),
              ),
            ),
          ],
        ),
        pw.ListView.builder(
          itemCount: item.productReports!.length,
          itemBuilder: (context, i) {
            return pw.Padding(
              padding: pw.EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    flex: 7,
                    child: pw.Text(
                      item.productReports![i].name!,
                      style: pw.TextStyle(font: font, fontSize: 7),
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text(
                          "${item.productReports![i].quantity}",
                          style: pw.TextStyle(font: font, fontSize: 7),
                        ),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Align(
                      alignment: pw.Alignment.centerRight,
                      child: pw.Text(
                        formatPrice(item.productReports![i].totalAmount!),
                        style: pw.TextStyle(font: font, fontSize: 7),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

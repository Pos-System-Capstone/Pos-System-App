import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../../enums/order_enum.dart';
import '../../../../../helper/qr_generate.dart';
import '../../../../widgets/other_dialogs/dialog.dart';
import '../payment.dart';

void showPaymentBotomSheet(String orderId) {
  Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: PaymentScreen(orderId)));
}

void showQRCodeDialog(String paymentName, num amount, String invoiceId) {
  String url = "";
  switch (paymentName) {
    case PaymentTypeEnums.MOMO:
      url =
          "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fz4464235422454_d2c520e8b760cfbb8b3d08777455cf4e.jpg?alt=media&token=40005ae3-1f9d-4176-8717-b4379608fc82";
      break;
    case PaymentTypeEnums.BANKING:
      url = vietQrGenerate(amount, invoiceId);
      break;
    default:
      url = vietQrGenerate(amount, invoiceId);
  }
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: Get.size.width * 0.8,
      height: Get.size.height * 0.8,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    paymentName,
                    style: Get.textTheme.titleLarge,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      hideDialog();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Get.theme.colorScheme.onBackground,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          Expanded(
            child: Image.network(
              url,
              height: Get.size.height * 0.5,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Get.find<PrinterViewModel>().printQRCode(url);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "In mã QR",
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

void scanQRCodeDialog(String paymentName, num amount, String invoiceId) {
  String url = "";
  switch (paymentName) {
    case PaymentTypeEnums.MOMO:
      url =
          "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fz4464235422454_d2c520e8b760cfbb8b3d08777455cf4e.jpg?alt=media&token=40005ae3-1f9d-4176-8717-b4379608fc82";
      break;
    case PaymentTypeEnums.BANKING:
      url = vietQrGenerate(amount, invoiceId);
      break;
    default:
      url = vietQrGenerate(amount, invoiceId);
  }
  hideDialog();
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: Get.size.width * 0.8,
      height: Get.size.height * 0.8,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Quét mã QR Code",
                    style: Get.textTheme.titleMedium,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    paymentName,
                    style: Get.textTheme.titleLarge,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      hideDialog();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Get.theme.colorScheme.onBackground,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(child: CachedNetworkImage(imageUrl: url)),
        ],
      ),
    ),
  ));
}

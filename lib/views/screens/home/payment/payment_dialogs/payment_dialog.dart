import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../widgets/other_dialogs/dialog.dart';
import '../payment.dart';

void showPaymentBotomSheet(String orderId) {
  Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: PaymentScreen(orderId)));
}

void showQRCodeDialog(String qrCode, String paymentName, String orderId) {
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
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: PrettyQr(
            elementColor: Get.theme.colorScheme.onBackground,
            size: 300,
            data: qrCode,
            errorCorrectLevel: QrErrorCorrectLevel.H,
            typeNumber: null,
          )),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.find<PrinterViewModel>()
                        .printQRCode(qrCode, paymentName);
                  },
                  child: Text("In ma QR"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    hideDialog();
                  },
                  child: Text("Hoàn thành"),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

void scanQRCodeDialog(String qrCode, String paymentName) {
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
          Expanded(child: CachedNetworkImage(imageUrl: qrCode)),
        ],
      ),
    ),
  ));
}

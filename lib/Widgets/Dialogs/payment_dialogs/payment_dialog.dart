import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/Widgets/order_process/payment.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../other_dialogs/dialog.dart';

void showPaymentBotomSheet(String orderId) {
  Get.bottomSheet(
      // isDismissible: true,
      isScrollControlled: true,
      PaymentScreen(orderId));
}

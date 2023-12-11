import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../enums/order_enum.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/other_dialogs/dialog.dart';

void chooseDeliTypeDialog() {
  hideDialog();
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      width: Get.width * 0.8,
      height: Get.height * 0.9,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
                alignment: Alignment.center,
                child: Text("Chọn phương thức nhận đơn",
                    style: Get.textTheme.titleLarge)),
          ),
          Divider(
            height: 1,
            color: Get.theme.colorScheme.onSurface,
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
              child: ScopedModel(
            model: Get.find<CartViewModel>(),
            child: ScopedModelDescendant<CartViewModel>(
                builder: (context, child, model) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          deliveryOptionButton(
                            DeliType().delivery.label,
                            DeliType().delivery.icon,
                            () =>
                                model.chooseOrderType(DeliType().delivery.type),
                            model.cart.orderType == DeliType().delivery.type,
                          ),
                          deliveryOptionButton(
                            DeliType().eatIn.label,
                            DeliType().eatIn.icon,
                            () => model.chooseOrderType(DeliType().eatIn.type),
                            model.cart.orderType == DeliType().eatIn.type,
                          ),
                          deliveryOptionButton(
                              DeliType().takeAway.label,
                              DeliType().takeAway.icon,
                              () => model
                                  .chooseOrderType(DeliType().takeAway.type),
                              model.cart.orderType == DeliType().takeAway.type),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          )),
        ],
      ),
    ),
  ));
}

Widget deliveryOptionButton(
    String title, IconData icon, Function() onTap, bool isSelected) {
  return InkWell(
    onTap: onTap,
    child: Card(
      color: isSelected
          ? Get.theme.colorScheme.primaryContainer
          : Get.theme.colorScheme.background,
      child: SizedBox(
        width: 120,
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                title,
                style: Get.textTheme.titleMedium,
              ),
            )
          ],
        ),
      ),
    ),
  );
}

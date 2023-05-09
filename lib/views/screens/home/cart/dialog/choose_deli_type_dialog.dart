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
            model: Get.find<OrderViewModel>(),
            child: ScopedModelDescendant<OrderViewModel>(
                builder: (context, child, model) {
              List<String> listPromotion = Get.find<RootViewModel>().promotions;
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
                            () => model
                                .chooseDeliveryType(DeliType().delivery.type),
                            model.deliveryType == DeliType().delivery.type,
                          ),
                          deliveryOptionButton(
                            DeliType().eatIn.label,
                            DeliType().eatIn.icon,
                            () =>
                                model.chooseDeliveryType(DeliType().eatIn.type),
                            model.deliveryType == DeliType().eatIn.type,
                          ),
                          deliveryOptionButton(
                              DeliType().takeAway.label,
                              DeliType().takeAway.icon,
                              () => model
                                  .chooseDeliveryType(DeliType().takeAway.type),
                              model.deliveryType == DeliType().takeAway.type),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          listPromotion.isNotEmpty
                              ? Expanded(
                                  child: ListView.builder(
                                    itemCount: listPromotion.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          listPromotion[index],
                                          style: Get.textTheme.titleMedium,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ))
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

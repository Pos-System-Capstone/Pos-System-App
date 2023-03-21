import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/order_enum.dart';
import '../../view_model/order_view_model.dart';

void chooseDeliTypeDialog() {
  hideDialog();
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      width: Get.size.width,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.delivery_dining_outlined, size: 32),
              ),
              Expanded(
                  child: Center(
                      child: Text("Chọn phương thức giao hàng",
                          style: Get.textTheme.titleLarge))),
              IconButton(
                  iconSize: 40,
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close))
            ],
          ),
          Expanded(
              child: ScopedModel(
            model: Get.find<OrderViewModel>(),
            child: ScopedModelDescendant<OrderViewModel>(
                builder: (context, child, model) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            deliveryOptionButton(
                              "Giao hàng",
                              Icons.delivery_dining,
                              () => model.chooseDeliveryType(DeliType.DELIVERY),
                              model.deliveryType == DeliType.DELIVERY,
                            ),
                            deliveryOptionButton(
                              "Tại chỗ",
                              Icons.store,
                              () => model.chooseDeliveryType(DeliType.EAT_IN),
                              model.deliveryType == DeliType.EAT_IN,
                            ),
                            deliveryOptionButton(
                                "Mang về",
                                Icons.coffee_maker_outlined,
                                () => model
                                    .chooseDeliveryType(DeliType.TAKE_AWAY),
                                model.deliveryType == DeliType.TAKE_AWAY),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
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

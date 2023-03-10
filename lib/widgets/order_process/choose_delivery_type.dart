import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/order_enum.dart';
import 'package:pos_apps/view_model/order_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ChooseDeliveryTypeScreen extends StatelessWidget {
  const ChooseDeliveryTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, child, model) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delivery_dining, size: 24),
                    onPressed: () {
                      model.changeState(OrderStateEnum.CHOOSE_ORDER_TYPE);
                    },
                  ),
                  Text("Chọn hình thức", style: Get.textTheme.titleLarge),
                ],
              ),
              Expanded(
                child: Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      deliveryOptionButton(
                        "Giao hàng",
                        Icons.delivery_dining,
                        () => model.chooseDeliveryType(DeliTypeEnum.DELIVERY),
                        model.deliveryType == DeliTypeEnum.DELIVERY,
                      ),
                      deliveryOptionButton(
                        "Tại chỗ",
                        Icons.store,
                        () => model.chooseDeliveryType(DeliTypeEnum.IN_STORE),
                        model.deliveryType == DeliTypeEnum.IN_STORE,
                      ),
                      deliveryOptionButton(
                          "Mang về",
                          Icons.coffee_maker_outlined,
                          () =>
                              model.chooseDeliveryType(DeliTypeEnum.TAKE_AWAY),
                          model.deliveryType == DeliTypeEnum.TAKE_AWAY),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}

Widget deliveryOptionButton(
    String title, IconData icon, Function() onTap, bool isSelected) {
  return InkWell(
    onTap: onTap,
    child: SizedBox(
      width: 120,
      height: 120,
      child: Card(
        color: isSelected
            ? Get.theme.colorScheme.primaryContainer
            : Get.theme.colorScheme.background,
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

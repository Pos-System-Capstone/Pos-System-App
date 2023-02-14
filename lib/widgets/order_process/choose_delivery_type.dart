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
          color: Get.theme.colorScheme.shadow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined, size: 24),
                    onPressed: () {
                      model.changeState(OrderStateEnum.CHOOSE_ORDER_TYPE);
                    },
                  ),
                  Text("1. Chọn hình thức giao hàng",
                      style: Get.textTheme.headlineSmall),
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
                        "Tại cửa hàng",
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
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        height: 160,
        child: Card(
          color: isSelected
              ? Get.theme.colorScheme.primary
              : Get.theme.colorScheme.background,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 72),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    title,
                    style: Get.textTheme.titleLarge,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

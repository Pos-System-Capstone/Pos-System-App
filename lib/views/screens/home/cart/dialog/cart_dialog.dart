import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cart_screen.dart';

void showCartDialog() {
  Get.dialog(Dialog.fullscreen(
    backgroundColor: Colors.transparent,
    child: Container(
      width: Get.size.width,
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.shopping_cart, size: 32),
              ),
              Expanded(
                  child: Center(
                      child:
                          Text("Giỏ hàng", style: Get.textTheme.titleLarge))),
              IconButton(
                  iconSize: 40,
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close))
            ],
          ),
          Expanded(child: CartScreen()),
        ],
      ),
    ),
  ));
}

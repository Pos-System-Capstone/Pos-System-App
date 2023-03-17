import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/index.dart';
import '../util/format.dart';
import 'cart/add_product_dialog.dart';

Widget productCard(Product product, List<Product>? childProducts) {
  if (childProducts == null) {
    return Card(
      child: Center(child: Text("Không có sản phẩm con")),
    );
  }
  return Card(
    child: InkWell(
      onTap: () => Get.dialog(ProductDialog(product: product)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name!,
                style: Get.theme.textTheme.bodyLarge,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                childProducts.isNotEmpty
                    ? "Từ ${formatPrice(childProducts[0].sellingPrice!)}"
                    : formatPrice(product.sellingPrice!),
                style: Get.theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget extraCart(Product extra) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  extra.name!,
                  style: Get.theme.textTheme.bodyMedium,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  formatPrice(extra.sellingPrice!),
                  style: Get.theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    debugPrint("remove");
                  },
                  icon: Icon(Icons.remove),
                  iconSize: 32,
                )),
                Text("0"),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    debugPrint("add");
                  },
                  icon: Icon(Icons.add),
                  iconSize: 32,
                )),
              ],
            ))
      ]),
    ),
  );
}

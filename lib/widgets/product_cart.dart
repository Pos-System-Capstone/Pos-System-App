import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/widgets/cart/add_product_bottom_sheet.dart';

import '../model/index.dart';
import '../util/format.dart';
import 'cart/add_product_dialog.dart';

Widget productCard(Product product, List<Product>? childsProduct) {
  var isPortrait = Get.context!.isPortrait;
  return Card(
    child: InkWell(
      onTap: () => Get.dialog(ProductDialog(product: product)),
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
                    product.name!,
                    style: Get.theme.textTheme.bodyMedium,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    childsProduct != null
                        ? "Từ ${formatPrice(childsProduct[0].sellingPrice!)}"
                        : formatPrice(product.sellingPrice!),
                    style: Get.theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //     flex: 2,
          //     child: Row(
          //       children: [
          //         Expanded(
          //             child: IconButton(
          //           onPressed: () {
          //             debugPrint("remove");
          //           },
          //           icon: Icon(Icons.remove),
          //           iconSize: 32,
          //         )),
          //         Expanded(
          //             child: IconButton(
          //           onPressed: () {
          //             debugPrint("add");
          //           },
          //           icon: Icon(Icons.add),
          //           iconSize: 32,
          //         )),
          //       ],
          //     ))
        ]),
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

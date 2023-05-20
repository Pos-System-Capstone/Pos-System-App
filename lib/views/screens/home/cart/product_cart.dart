import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/model/index.dart';
import '../../../../enums/product_enum.dart';
import '../../../../util/format.dart';
import 'dialog/add_product_dialog.dart';

Widget productCard(Product product, List<Product>? childProducts) {
  if (childProducts == null && product.type == ProductTypeEnum.PARENT) {
    return Card(
      child: Center(child: Text("Không có sản phẩm con")),
    );
  }
  return Card(
    child: InkWell(
      onTap: () => Get.dialog(ProductDialog(product: product)),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image: NetworkImage(product.picUrl ??
                            "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fdownload.png?alt=media&token=d3d049e8-536e-4939-bb93-2704647445b4"),
                        fit: BoxFit.cover)),
              ),
              // child: Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //   ),
              //   child: CachedNetworkImage(
              //     imageUrl: (product.picUrl ??
              //         "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fdownload.png?alt=media&token=d3d049e8-536e-4939-bb93-2704647445b4"),
              //     placeholder: (context, url) => CircularProgressIndicator(),
              //     errorWidget: (context, url, error) => Icon(Icons.error),
              //   ),
              // ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(4),
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
                    alignment: Alignment.bottomRight,
                    child: (childProducts != null &&
                            product.type == ProductTypeEnum.PARENT)
                        ? Text("")
                        : Text(
                            formatPrice(product.sellingPrice!),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
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

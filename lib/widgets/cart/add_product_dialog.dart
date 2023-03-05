import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:pos_apps/widgets/cart/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model/index.dart';
import '../product_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/product_enum.dart';
import '../../model/index.dart';
import '../../util/format.dart';
import '../../view_model/menu_view_model.dart';
import '../../view_model/product_view_model.dart';
import '../product_cart.dart';

class ProductDialog extends StatefulWidget {
  final Product product;
  const ProductDialog({required this.product, super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  ProductViewModel productViewModel = ProductViewModel();
  List<Product> childProducts = [];
  List<Product> extraProduct = [];
  String? selectedSize;
  @override
  void initState() {
    super.initState();
    productViewModel.addProductToCartItem(widget.product);
    extraProduct =
        menuViewModel.getExtraProductByNormalProduct(widget.product)!;
    if (widget.product.type == ProductTypeEnum.PARENT) {
      childProducts =
          menuViewModel.getChildProductByParentProduct(widget.product.id!)!;
      selectedSize = childProducts[0].id;
      productViewModel.addProductToCartItem(childProducts[0]);
    }
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedSize = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> parentProductTab = [
      Tab(
        child: Text("Tuỳ chỉnh", style: Get.textTheme.titleMedium),
      ),
      Tab(
        child: Text("Món thêm", style: Get.textTheme.titleMedium),
      ),
      Tab(
        child: Text("Ghi chú", style: Get.textTheme.titleMedium),
      ),
    ];
    List<Tab> singleProductTab = [
      Tab(
        child: Text("Món thêm", style: Get.textTheme.titleMedium),
      ),
      Tab(
        child: Text("Ghi chú", style: Get.textTheme.titleMedium),
      ),
    ];
    bool isPortrait = Get.context!.isPortrait;
    return Dialog(
        child: ScopedModel<ProductViewModel>(
      model: productViewModel,
      child: ScopedModelDescendant(
        builder: (context, child, ProductViewModel model) {
          return Container(
            width: isPortrait ? Get.size.width : Get.size.width * 0.4,
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.onInverseSurface,
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_cart),
                    ),
                    Expanded(
                        child: Center(
                            child: Text("Tuỳ chọn sản phẩm",
                                style: Get.textTheme.titleMedium))),
                    IconButton(
                        iconSize: 32,
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close))
                  ],
                ),
                Expanded(
                  child: DefaultTabController(
                    length:
                        widget.product.type == ProductTypeEnum.PARENT ? 3 : 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: widget.product.type == ProductTypeEnum.PARENT
                              ? parentProductTab
                              : singleProductTab,
                          isScrollable: true,
                          indicatorColor: Get.theme.colorScheme.primary,
                        ),
                        Expanded(
                          child: TabBarView(
                              children:
                                  widget.product.type == ProductTypeEnum.PARENT
                                      ? [
                                          productSize(model),
                                          addExtra(model),
                                          productNotes(model),
                                        ]
                                      : [
                                          addExtra(model),
                                          productNotes(model),
                                        ]),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tổng tiền",
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatPrice(model.totalAmount!),
                              style: Get.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                            onPressed: () {
                              model.addProductToCart();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("Thêm ",
                                  style: Get.textTheme.titleMedium),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  model.decreaseQuantity();
                                },
                                icon: Icon(
                                  Icons.remove,
                                  size: 32,
                                )),
                            Text("${model.quantity}",
                                style: Get.textTheme.titleLarge),
                            IconButton(
                                onPressed: () {
                                  model.increaseQuantity();
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 32,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget productSize(ProductViewModel model) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: childProducts.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) {
                return RadioListTile(
                  contentPadding: EdgeInsets.all(8),
                  // dense: true,
                  visualDensity: VisualDensity(
                    horizontal: VisualDensity.maximumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Size ${childProducts[i].size!}"),
                      Text(formatPrice(childProducts[i].sellingPrice!)),
                    ],
                  ),
                  value: childProducts[i].id,
                  groupValue: selectedSize,
                  selected: selectedSize == childProducts[i].id,
                  onChanged: (value) {
                    model.addProductToCartItem(childProducts[i]);
                    setSelectedRadio(value!);
                  },
                );
              },
            ),
          ],
        ));
  }

  Widget addExtra(ProductViewModel model) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: extraProduct.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                bool isSelect = false;
                return CheckboxListTile(
                  contentPadding: EdgeInsets.all(8),
                  // dense: true,
                  visualDensity: VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(extraProduct[i].name!),
                      Text("+ ${formatPrice(extraProduct[i].sellingPrice!)}"),
                    ],
                  ),
                  value: model.isExtraExist(extraProduct[i]),
                  // selected: isSelect,
                  onChanged: (value) {
                    model.addOrRemoveExtra(extraProduct[i]);
                  },
                );
              },
            ),
          ],
        ));
  }

  Widget productNotes(ProductViewModel model) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Ghi chú',
              style: Get.textTheme.titleSmall,
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ));
  }
}

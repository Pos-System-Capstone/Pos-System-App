import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:pos_apps/widgets/cart/cart_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../data/model/index.dart';
import '../product_cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/product_enum.dart';
import '../../data/model/index.dart';
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
  List<Category> extraCategory = [];
  String? selectedSize;
  @override
  void initState() {
    super.initState();
    productViewModel.addProductToCartItem(widget.product);
    extraCategory =
        menuViewModel.getExtraCategoryByNormalProduct(widget.product)!;

    if (widget.product.type == ProductTypeEnum.PARENT) {
      childProducts =
          menuViewModel.getChildProductByParentProduct(widget.product.id!)!;
      if (childProducts.isNotEmpty) {
        selectedSize = childProducts[0].id;
      }
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
        child: Text("Kích cỡ", style: Get.textTheme.titleMedium),
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
            width: isPortrait ? Get.size.width : Get.size.width * 0.6,
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
                      child: Icon(
                        Icons.shopping_cart,
                        size: 32,
                      ),
                    ),
                    Expanded(
                        child: Center(
                            child: Text("Tuỳ chọn",
                                style: Get.textTheme.titleLarge))),
                    IconButton(
                        iconSize: 40,
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
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
                                  style: Get.textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
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
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: double.infinity,
                        child: FilledButton.tonal(
                            onPressed: () {
                              model.addProductToCart();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text("Thêm ",
                                  style: Get.textTheme.titleLarge),
                            )),
                      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  Widget addExtra(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: extraCategory.map((e) {
              List<Product> extraProduct =
                  menuViewModel.getProductsByCategory(e.id);
              return Column(
                children: [
                  Text(e.name!, style: Get.textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: extraProduct.length,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, i) {
                      return CheckboxListTile(
                        contentPadding: EdgeInsets.all(8),
                        // dense: true,
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.minimumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(extraProduct[i].name!),
                            Text(
                                "+ ${formatPrice(extraProduct[i].sellingPrice!)}"),
                          ],
                        ),

                        value: model.isExtraExist(extraProduct[i]),
                        selected: model.isExtraExist(extraProduct[i]),
                        onChanged: (value) {
                          model.addOrRemoveExtra(extraProduct[i]);
                        },
                      );
                    },
                  ),
                ],
              );
            }).toList()),
      ),
    );
  }

  Widget productNotes(ProductViewModel model) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Ghi chú",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                model.setNotes(value);
              },
            ),
          ],
        ));
  }
}

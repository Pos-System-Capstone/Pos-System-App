import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/cart_model.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../data/model/index.dart';

class UpdateCartItemDialog extends StatefulWidget {
  final ProductList cartItem;
  final int idx;
  const UpdateCartItemDialog(
      {required this.cartItem, required this.idx, super.key});

  get parentProduct => null;

  @override
  State<UpdateCartItemDialog> createState() => _UpdateCartItemDialogState();
}

class _UpdateCartItemDialogState extends State<UpdateCartItemDialog> {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  ProductViewModel productViewModel = ProductViewModel();
  List<Product> childProducts = [];
  List<Category> extraCategory = [];
  String? selectedSize;
  List<Variants> listVariants = [];
  List<Attributes> selectedAttributes = [];
  List<GroupProducts> groupProducts = [];
  Product? parentProduct;
  @override
  void initState() {
    super.initState();
    productViewModel.getCartItemToUpdate(widget.cartItem);
    if (widget.cartItem.type == ProductTypeEnum.CHILD) {
      childProducts = menuViewModel.getChildProductByParentProduct(
          productViewModel.productInCart.parentProductId!)!;
      selectedSize = productViewModel.productInCart.productInMenuId;
      extraCategory = menuViewModel
          .getExtraCategoryByChildProduct(widget.cartItem.parentProductId!)!;
      parentProduct =
          menuViewModel.getProductById(widget.cartItem.parentProductId ?? "");
    } else {
      parentProduct = menuViewModel
          .getProductByMenuProductId(widget.cartItem.productInMenuId ?? "");
      extraCategory = menuViewModel
          .getExtraCategoryByNormalProduct(widget.cartItem.productInMenuId!)!;
    }
    if (parentProduct != null &&
        parentProduct?.variants != null &&
        parentProduct!.variants!.isNotEmpty) {
      listVariants = parentProduct!.variants!;
      for (var attribute in listVariants) {
        var exitedAtr = widget.cartItem.attributes!
            .firstWhereOrNull((element) => element.name == attribute.name);
        if (exitedAtr == null) {
          selectedAttributes.add(Attributes(name: attribute.name, value: null));
        } else {
          selectedAttributes
              .add(Attributes(name: exitedAtr.name, value: exitedAtr.value));
        }
      }
    }
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedSize = val;
    });
  }

  setAttributes(int idx, String val) {
    setState(() {
      selectedAttributes[idx].value = val;
    });
  }

  removeAttributes(int idx) {
    setState(() {
      selectedAttributes[idx].value = "";
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: SingleChildScrollView(
                    child: Column(
                        children: widget.cartItem.type == ProductTypeEnum.CHILD
                            ? [
                                productSize(model),
                                addExtra(model),
                                buildProductAttributes(model)
                              ]
                            : widget.cartItem.type == ProductTypeEnum.COMBO
                                ? [
                                    addExtra(model),
                                    buildProductAttributes(model),
                                  ]
                                : [
                                    addExtra(model),
                                    buildProductAttributes(model)
                                  ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: model.productInCart.note,
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
                      )),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    model.decreaseQuantity();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    size: 48,
                                  )),
                              Text("${model.productInCart.quantity}",
                                  style: Get.textTheme.titleLarge),
                              IconButton(
                                  onPressed: () {
                                    model.increaseQuantity();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    size: 48,
                                  )),
                            ],
                          ),
                          model.productInCart.quantity == 0
                              ? Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        model.deleteCartItemInCart(widget.idx);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 16, 4, 16),
                                        child: Text("Xóa",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color: Get.theme.colorScheme
                                                        .background)),
                                      )),
                                )
                              : Expanded(
                                  child: FilledButton(
                                      onPressed: () {
                                        model.updateCartItemInCart(widget.idx);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            4, 16, 4, 16),
                                        child: Text(
                                            "Cập nhật ${formatPrice(model.productInCart.finalAmount!)}",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color: Get.theme.colorScheme
                                                        .background)),
                                      )),
                                )
                        ],
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Kích cỡ", style: Get.textTheme.titleMedium),
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
                  Text("Size ${childProducts[i].name!}"),
                  Text(formatPrice(childProducts[i].sellingPrice!)),
                ],
              ),
              value: childProducts[i].menuProductId,
              groupValue: selectedSize,
              selected: selectedSize == childProducts[i].menuProductId,
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
    return SingleChildScrollView(
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

                      value: model
                          .isExtraExist(extraProduct[i].menuProductId ?? ""),
                      selected: model
                          .isExtraExist(extraProduct[i].menuProductId ?? ""),
                      onChanged: (value) {
                        model.addOrRemoveExtra(extraProduct[i]);
                      },
                    );
                  },
                ),
              ],
            );
          }).toList()),
    );
  }

  // Widget comboProduct(ProductViewModel model) {
  //   return SingleChildScrollView(
  //     child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: groupProducts.map((e) {
  //           List<ProductsInGroup> productInGroup =
  //               menuViewModel.getListProductInGroup(e.id);
  //           return Column(
  //             children: [
  //               Text(e.name!, style: Get.textTheme.titleMedium),
  //               ListView.builder(
  //                 shrinkWrap: true,
  //                 itemCount: productInGroup.length,
  //                 physics: ScrollPhysics(),
  //                 itemBuilder: (context, i) {
  //                   Product currentProduct = menuViewModel
  //                       .getProductById(productInGroup[i].productId!);
  //                   return CheckboxListTile(
  //                     // dense: true,
  //                     visualDensity: VisualDensity(
  //                       horizontal: VisualDensity.minimumDensity,
  //                       vertical: VisualDensity.minimumDensity,
  //                     ),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text(currentProduct.name!),
  //                         Text(
  //                             "+ ${formatPrice(productInGroup[i].additionalPrice!)}"),
  //                       ],
  //                     ),
  //                     enabled:
  //                         (model.countProductInGroupInExtra(productInGroup) <
  //                                 e.quantity! ||
  //                             model.isExtraExist(currentProduct.id ?? "")),
  //                     value: model.isExtraExist(currentProduct.id ?? ""),
  //                     selected: model.isExtraExist(currentProduct.id ?? ""),
  //                     onChanged: (value) => {
  //                       currentProduct.sellingPrice =
  //                           productInGroup[i].additionalPrice,
  //                       model.addOrRemoveExtra(currentProduct)
  //                     },
  //                   );
  //                 },
  //               ),
  //             ],
  //           );
  //         }).toList()),
  //   );
  // }

  Widget buildProductAttributes(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < listVariants.length; i++)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(listVariants[i].name, style: Get.textTheme.bodyLarge),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: listVariants[i]
                      .value!
                      .split("_")
                      .map((option) => TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                selectedAttributes.isNotEmpty
                                    ? (selectedAttributes
                                            .where((element) =>
                                                element.value == option)
                                            .isNotEmpty
                                        ? Get.theme.colorScheme.primaryContainer
                                        : Colors.transparent)
                                    : Colors.transparent),
                          ),
                          onPressed: () {
                            setAttributes(i, option);
                            model.setAttributes(Attributes(
                                name: listVariants[i].name, value: option));
                          },
                          child: Text(
                            option,
                          )))
                      .toList(),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

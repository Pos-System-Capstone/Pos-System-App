import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../data/model/index.dart';

class UpdateCartItemDialog extends StatefulWidget {
  final CartItem cartItem;
  final int idx;
  const UpdateCartItemDialog(
      {required this.cartItem, required this.idx, super.key});

  @override
  State<UpdateCartItemDialog> createState() => _UpdateCartItemDialogState();
}

class _UpdateCartItemDialogState extends State<UpdateCartItemDialog> {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  ProductViewModel productViewModel = ProductViewModel();
  List<Product> childProducts = [];
  List<Category> extraCategory = [];
  String? selectedSize;
  List<Attribute> listAttribute = [];
  List<ProductAttribute> selectedAttributes = [];
  List<GroupProducts> groupProducts = [];
  @override
  void initState() {
    super.initState();
    productViewModel.getCartItemToUpdate(widget.cartItem);
    extraCategory =
        menuViewModel.getExtraCategoryByNormalProduct(widget.cartItem.product)!;
    if (widget.cartItem.product.type == ProductTypeEnum.CHILD) {
      childProducts = menuViewModel.getChildProductByParentProduct(
          productViewModel.productInCart!.parentProductId!)!;
      selectedSize = productViewModel.productInCart!.id;
    }
    if (widget.cartItem.product.type == ProductTypeEnum.COMBO) {
      groupProducts = menuViewModel
          .getGroupProductByComboProduct(widget.cartItem.product.id!)!;
    }
    listAttribute = productViewModel.listAttribute;
    selectedAttributes = widget.cartItem.attributes!;
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
                        children: widget.cartItem.product.type ==
                                ProductTypeEnum.CHILD
                            ? [
                                productSize(model),
                                addExtra(model),
                                productAttributes(model)
                              ]
                            : widget.cartItem.product.type ==
                                    ProductTypeEnum.COMBO
                                ? [
                                    comboProduct(model),
                                    addExtra(model),
                                    productAttributes(model),
                                  ]
                                : [addExtra(model), productAttributes(model)]),
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
                            initialValue: model.notes,
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
                              Text("${model.quantity}",
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
                          model.quantity == 0
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
                                            "Cập nhật ${formatPrice(model.totalAmount!)}",
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

                      value: model.isExtraExist(extraProduct[i].id ?? ""),
                      selected: model.isExtraExist(extraProduct[i].id ?? ""),
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

  Widget comboProduct(ProductViewModel model) {
    return SingleChildScrollView(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: groupProducts.map((e) {
            List<ProductsInGroup> productInGroup =
                menuViewModel.getListProductInGroup(e.id);
            return Column(
              children: [
                Text(e.name!, style: Get.textTheme.titleMedium),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: productInGroup.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, i) {
                    Product currentProduct = menuViewModel
                        .getProductById(productInGroup[i].productId!);
                    return CheckboxListTile(
                      // dense: true,
                      visualDensity: VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(currentProduct.name!),
                          Text(
                              "+ ${formatPrice(productInGroup[i].additionalPrice!)}"),
                        ],
                      ),
                      enabled:
                          (model.countProductInGroupInExtra(productInGroup) <
                                  e.quantity! ||
                              model.isExtraExist(currentProduct.id ?? "")),
                      value: model.isExtraExist(currentProduct.id ?? ""),
                      selected: model.isExtraExist(currentProduct.id ?? ""),
                      onChanged: (value) => {
                        currentProduct.sellingPrice =
                            productInGroup[i].additionalPrice,
                        model.addOrRemoveExtra(currentProduct)
                      },
                    );
                  },
                ),
              ],
            );
          }).toList()),
    );
  }

  Widget productAttributes(ProductViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          children: [
            for (int i = 0; i < listAttribute.length; i++)
              Column(
                children: [
                  Text(listAttribute[i].name, style: Get.textTheme.titleMedium),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: listAttribute[i].options.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, idx) {
                      return RadioListTile(
                        visualDensity: VisualDensity(
                          horizontal: VisualDensity.maximumDensity,
                          vertical: VisualDensity.minimumDensity,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(listAttribute[i].options[idx]),
                          ],
                        ),
                        value: listAttribute[i].options[idx],
                        groupValue: selectedAttributes[i].value,
                        selected: selectedAttributes[i].value ==
                            listAttribute[i].options[idx],
                        onChanged: (value) {
                          setAttributes(i, value!);
                          model.setAttributes(selectedAttributes[i]);
                        },
                      );
                    },
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

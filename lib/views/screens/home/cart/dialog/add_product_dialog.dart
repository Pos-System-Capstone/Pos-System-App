import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/product_attribute.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../data/model/index.dart';

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
  List<Attribute> listAttribute = [];
  List<ProductAttribute> selectedAttributes = [];
  List<GroupProducts> groupProducts = [];

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
    if (widget.product.type == ProductTypeEnum.COMBO) {
      groupProducts =
          menuViewModel.getGroupProductByComboProduct(widget.product.id!)!;
    }
    listAttribute = productViewModel.listAttribute;
    selectedAttributes = productViewModel.currentAttributes;
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
                        children: widget.product.type == ProductTypeEnum.PARENT
                            ? [
                                productSize(model),
                                addExtra(model),
                                productAttributes(model),
                              ]
                            : widget.product.type == ProductTypeEnum.COMBO
                                ? [
                                    comboProduct(model),
                                    addExtra(model),
                                    productAttributes(model),
                                  ]
                                : [
                                    addExtra(model),
                                    productAttributes(model),
                                  ]),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(4),
                  width: double.infinity,
                  child: Column(
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
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                if (model.quantity > 1) {
                                  model.decreaseQuantity();
                                }
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
                          Expanded(
                            child: FilledButton(
                                onPressed: () {
                                  model.addProductToCart();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 16, 4, 16),
                                  child: Text(
                                      "Thêm ${formatPrice(model.totalAmount!)}",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.colorScheme
                                                  .background)),
                                )),
                          ),
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
                Text("${e.name!} (Tối đa ${e.quantity} sản phẩm)",
                    style: Get.textTheme.titleMedium),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: productInGroup.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, i) {
                    Product currentProduct = menuViewModel
                        .getProductById(productInGroup[i].productId!);
                    return CheckboxListTile(
                      visualDensity: VisualDensity(
                        horizontal: VisualDensity.maximumDensity,
                        vertical: VisualDensity.maximumDensity,
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentProduct.name!,
                            maxLines: 2,
                          ),
                          Text(
                              "+ ${formatPrice(productInGroup[i].additionalPrice!)}"),
                        ],
                      ),
                      value: model.isExtraExist(currentProduct.id ?? ""),
                      selected: model.isExtraExist(currentProduct.id ?? ""),
                      enabled:
                          (model.countProductInGroupInExtra(productInGroup) <
                                  e.quantity! ||
                              model.isExtraExist(currentProduct.id ?? "")),
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
                          vertical: VisualDensity.maximumDensity,
                        ),
                        title: Text(
                          listAttribute[i].options[idx],
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

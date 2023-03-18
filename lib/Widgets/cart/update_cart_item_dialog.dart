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
  List<Product> extraProduct = [];
  String? selectedSize;
  String? selectedIceNote;
  String? selectedSugarNote;
  @override
  void initState() {
    super.initState();
    productViewModel.getCartItemToUpdate(widget.cartItem);
    extraProduct = menuViewModel
        .getExtraProductByNormalProduct(productViewModel.productInCart!)!;
    if (widget.cartItem.product.type == ProductTypeEnum.CHILD) {
      childProducts = menuViewModel.getChildProductByParentProduct(
          productViewModel.productInCart!.parentProductId!)!;
      selectedSize = productViewModel.productInCart!.id;
      selectedSugarNote = productViewModel.sugarNote;
      selectedIceNote = productViewModel.iceNote;
    }
  }

  setSelectedRadio(String val) {
    setState(() {
      selectedSize = val;
    });
  }

  setSelectedSugar(String val) {
    setState(() {
      selectedSugarNote = val;
    });
  }

  setSelectedIce(String val) {
    setState(() {
      selectedIceNote = val;
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
                        widget.cartItem.product.type == ProductTypeEnum.CHILD
                            ? 3
                            : 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          tabs: widget.cartItem.product.type ==
                                  ProductTypeEnum.CHILD
                              ? parentProductTab
                              : singleProductTab,
                          isScrollable: true,
                          indicatorColor: Get.theme.colorScheme.primary,
                        ),
                        Expanded(
                          child: TabBarView(
                              children: widget.cartItem.product.type ==
                                      ProductTypeEnum.CHILD
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: OutlinedButton(
                                  onPressed: () {
                                    model.deleteCartItemInCart(widget.idx);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text("Xoá",
                                        style: Get.textTheme.titleMedium),
                                  )),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              flex: 2,
                              child: FilledButton(
                                  onPressed: () {
                                    model.updateCartItemInCart(widget.idx);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text("Cập nhật ",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.colorScheme
                                                    .background)),
                                  )),
                            ),
                          ],
                        ),
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
    return Column(
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
              title: Text(extraProduct[i].name!),
              subtitle: Text("+ ${formatPrice(extraProduct[i].sellingPrice!)}"),
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
  }

  Widget productNotes(ProductViewModel model) {
    return Container(
        padding: EdgeInsets.all(8),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Ghi chú nhanh nếu có",
                style: Get.textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                        itemCount: sugarNoteEnums.length,
                        itemBuilder: (context, i) {
                          return RadioListTile(
                            // dense: true,
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                            title: Text(" ${sugarNoteEnums[i]}"),
                            value: sugarNoteEnums[i],
                            groupValue: selectedSugarNote,
                            selected: selectedSugarNote == sugarNoteEnums[i],
                            onChanged: (value) {
                              model.addSugarNotes(sugarNoteEnums[i]);
                              setSelectedSugar(value!);
                              // setSelectedRadio(value!);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: iceNoteEnums.length,
                      itemBuilder: (context, i) {
                        return RadioListTile(
                          // dense: true,
                          visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          title: Text(" ${iceNoteEnums[i]}"),
                          value: iceNoteEnums[i],
                          groupValue: selectedIceNote,
                          onChanged: (value) {
                            model.addIceNotes(iceNoteEnums[i]);
                            setSelectedIce(value!);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}

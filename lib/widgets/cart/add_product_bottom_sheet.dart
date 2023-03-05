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

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  const ProductBottomSheet({required this.product, super.key});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
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
    return BottomSheet(
        onClosing: () {},
        builder: (context) {
          return ScopedModel<ProductViewModel>(
            model: productViewModel,
            child: ScopedModelDescendant(
              builder: (context, child, ProductViewModel model) {
                var isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                return Container(
                  width: isPortrait ? 400 : 500,
                  height: MediaQuery.of(context).size.height * 0.8,
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.onInverseSurface,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
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
                          length: widget.product.type == ProductTypeEnum.PARENT
                              ? 3
                              : 2,
                          child: Column(
                            children: [
                              TabBar(
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: widget.product.type ==
                                        ProductTypeEnum.PARENT
                                    ? parentProductTab
                                    : singleProductTab,
                                isScrollable: true,
                                indicatorColor: Get.theme.colorScheme.primary,
                              ),
                              Expanded(
                                child: TabBarView(
                                    children: widget.product.type ==
                                            ProductTypeEnum.PARENT
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
                              flex: 4,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text("Thêm vào giỏ hàng",
                                      style: Get.textTheme.titleMedium)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          );
        });
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

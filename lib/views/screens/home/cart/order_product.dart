import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../data/model/category.dart';
import '../../../../enums/index.dart';
import '../../../../enums/product_enum.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../view_model/index.dart';
import 'product_cart.dart';

class OrderProduct extends StatefulWidget {
  const OrderProduct({super.key});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  Category? selectCate;
  List<Tab> listSubCategoryTab = [];
  List<Category>? listSubCate;
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<MenuViewModel>(),
      child: ScopedModelDescendant<MenuViewModel>(
          builder: (context, child, model) {
        if (model.status == ViewStatus.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Tab>? listCategoryTab;

        listCategoryTab = model.categories!.map((e) {
          return Tab(
            height: 48,
            child: Text(e.name ?? '', style: Get.textTheme.titleLarge),
          );
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            children: [
              DefaultTabController(
                length: listCategoryTab.length,
                child: TabBar(
                  isScrollable: true,
                  indicatorColor: Get.theme.colorScheme.primary,
                  tabs: listCategoryTab,
                  onTap: (value) {
                    debugPrint("value: $value");

                    setState(() {
                      selectCate = model.categories![value];
                      listSubCate =
                          model.getChildCategory(model.categories![value]);

                      listSubCategoryTab = model
                          .getChildCategory(model.categories![value])!
                          .map((e) {
                        return Tab(
                          height: 48,
                          child: Text(e.name ?? '',
                              style: Get.textTheme.titleLarge),
                        );
                      }).toList();
                    });
                    model.handleChangeFilterProductByCategory(
                        model.categories![value].id);
                  },
                ),
              ),
              listSubCategoryTab.isNotEmpty
                  ? DefaultTabController(
                      length: listSubCategoryTab.length,
                      child: TabBar(
                        isScrollable: true,
                        indicatorColor: Get.theme.colorScheme.primary,
                        tabs: listSubCategoryTab,
                        onTap: (value) {
                          debugPrint("value: $value");
                          model.handleChangeFilterProductByCategory(
                              listSubCate![value].id);
                        },
                      ),
                    )
                  : SizedBox(),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GridView.count(
                    scrollDirection: Axis.vertical,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    childAspectRatio: 3,
                    crossAxisCount: ResponsiveHelper.isDesktop()
                        ? 3
                        : ResponsiveHelper.isTab()
                            ? 2
                            : ResponsiveHelper.isSmallTab()
                                ? 2
                                : ResponsiveHelper.isMobile()
                                    ? 1
                                    : 1,
                    children: [
                      for (int i = 0; i < model.productsFilter!.length; i++)
                        productCard(
                            model.productsFilter![i],
                            model.productsFilter![i].type ==
                                    ProductTypeEnum.PARENT
                                ? model.getChildProductByParentProduct(
                                    model.productsFilter![i].id)
                                : null)
                    ]),
              ))
            ],
          ),
        );
      }),
    );
  }
}

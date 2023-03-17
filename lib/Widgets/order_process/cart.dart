import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/helper/responsive_helper.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/widgets/cart/add_product_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/order_enum.dart';
import '../../data/model/index.dart';
import '../../util/format.dart';
import '../../view_model/order_view_model.dart';
import '../cart/cart_screen.dart';
import '../product_cart.dart';

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          return Column(
            children: [
              Expanded(
                child: Row(
                  children: context.isPortrait
                      ? [
                          Expanded(
                            child: orderProduct(context.isPortrait),
                          ),
                        ]
                      : [
                          Expanded(
                              flex: 2, child: orderProduct(context.isPortrait)),
                          Expanded(flex: 1, child: CartScreen()),
                        ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget orderProduct(bool isPortrait) {
  return ScopedModel(
    model: Get.find<MenuViewModel>(),
    child:
        ScopedModelDescendant<MenuViewModel>(builder: (context, child, model) {
      if (model.status == ViewStatus.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      List<Tab>? listCategoryTab;
      listCategoryTab = model.currentMenu?.categories!.map((e) {
        return Tab(
          height: 40,
          text: e.name,
        );
      }).toList();
      listCategoryTab?.insert(
          0,
          Tab(
            height: 40,
            text: "Tất cả",
          ));
      return Padding(
        padding: const EdgeInsets.all(4),
        child: DefaultTabController(
          length: listCategoryTab != null ? listCategoryTab.length : 0,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: Get.theme.colorScheme.primary,
                tabs: listCategoryTab!,
                onTap: (value) {
                  debugPrint("value: $value");
                  if (value == 0) {
                    model.handleChangeFilterProductByCategory(null);
                  } else {
                    model.handleChangeFilterProductByCategory(
                        model.currentMenu?.categories![value - 1].id);
                  }
                },
              ),
              Expanded(
                  child: GridView.count(
                      scrollDirection: Axis.vertical,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      crossAxisCount: ResponsiveHelper.isDesktop()
                          ? 6
                          : ResponsiveHelper.isTab()
                              ? 5
                              : ResponsiveHelper.isSmallTab()
                                  ? 4
                                  : ResponsiveHelper.isMobile()
                                      ? 3
                                      : 2,
                      children: [
                    for (int i = 0; i < model.productsFilter!.length; i++)
                      productCard(
                          model.productsFilter![i],
                          model.productsFilter![i].type ==
                                  ProductTypeEnum.PARENT
                              ? model.getChildProductByParentProduct(
                                  model.productsFilter![i].id)
                              : null)
                  ]))
            ],
          ),
        ),
      );
    }),
  );
}

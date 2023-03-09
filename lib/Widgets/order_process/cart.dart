import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
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
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          return Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      model.changeState(OrderStateEnum.BOOKING_TABLE);
                    },
                  ),
                  Text("3. Chọn món", style: Get.textTheme.titleLarge),
                ],
              ),
              Expanded(
                child: Row(
                  children: isPortrait
                      ? [
                          Expanded(
                            child: orderProduct(isPortrait),
                          ),
                        ]
                      : [
                          Expanded(flex: 5, child: orderProduct(isPortrait)),
                          Expanded(flex: 2, child: CartScreen()),
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
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(color: Get.theme.colorScheme.onBackground),
            borderRadius: BorderRadius.circular(8),
          ),
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
                        crossAxisCount: isPortrait ? 2 : 5,
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
        ),
      );
    }),
  );
}

Widget checkoutOrder() {
  return Container(
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Mã đơn: ABCXYZ',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Bàn: 01',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    VerticalDivider(),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Tại quầy',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Get.theme.colorScheme.onSurface,
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Row(
                  textDirection: TextDirection.ltr,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'SL',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Tên',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Size',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Tổng',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Get.theme.colorScheme.onSurface,
                thickness: 1,
              ),
            ],
          ),
        )
      ],
    ),
  );
}

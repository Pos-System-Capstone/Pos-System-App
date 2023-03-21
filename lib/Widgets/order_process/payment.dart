import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/widgets/cart/add_product_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/order_enum.dart';
import '../../data/model/index.dart';
import '../../util/format.dart';
import '../../view_model/order_view_model.dart';
import '../cart/cart_screen.dart';
import '../orders/bill_screen.dart';
import '../product_cart.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<OrderViewModel>().getOrderByStore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, child, model) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Get.context!.isPortrait
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: double.infinity,
                            height: 300,
                            child: orderConfig()),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: BillScreen(),
                          ),
                        )
                      ],
                    )
                  : Row(children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: orderConfig(),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: BillScreen(),
                          ))
                    ]),
            );
          },
        ),
      ),
    );
  }
}

Widget orderConfig() {
  return ScopedModel(
    model: Get.find<OrderViewModel>(),
    child:
        ScopedModelDescendant<OrderViewModel>(builder: (context, child, model) {
      List<Tab>? listPaymentTab = [
        Tab(text: "Thanh toán", icon: Icon(Icons.payment)),
        Tab(
          text: "Khách hàng",
          icon: Icon(Icons.person),
        ),
        Tab(
          text: "Khuyến mãi",
          icon: Icon(Icons.local_offer),
        ),
        // Tab(
        //   text: "Đơn hàng",
        //   icon: Icon(Icons.receipt),
        // ),
      ];
      return DefaultTabController(
        length: listPaymentTab.length,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TabBar(
              indicatorColor: Get.theme.colorScheme.primary,
              tabs: listPaymentTab,
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child: TabBarView(
              children: [
                paymentTypeSelect(model),
                customerInfoSelect(model),
                promotionTypeSelect(model),
                // BillScreen(),
              ],
            ))
          ],
        ),
      );
    }),
  );
}

Widget paymentTypeSelect(OrderViewModel model) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(8),
    ),
    width: double.infinity,
    height: double.infinity,
    child: Column(
      children: [
        Expanded(
          child: Center(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: model.listPayment
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () {
                          model.selectPayment(e);
                        },
                        child: Card(
                          color: model.selectedPaymentMethod == e
                              ? Get.theme.colorScheme.primary
                              : Get.theme.colorScheme.onInverseSurface,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  e!.picUrl!,
                                  width: 120,
                                  height: 120,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                    e.name!,
                                    style: Get.textTheme.titleLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                model.updatePayment();
              },
              child: Text("Thanh toán"),
            ),
          ),
        ),
      ],
    ),
  ));
}

Widget customerInfoSelect(OrderViewModel model) {
  return Container(child: Text("Khach hang"));
}

Widget promotionTypeSelect(OrderViewModel model) {
  return Container(child: Text("Khuyến mãi"));
}

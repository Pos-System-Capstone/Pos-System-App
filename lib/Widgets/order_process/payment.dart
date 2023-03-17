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
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          OrderResponseModel order = model.orderResponseModel!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(" Thanh toán", style: Get.textTheme.titleLarge),
                  ],
                ),
                Expanded(
                    child: Get.context!.isPortrait
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(child: orderConfig()),
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
                          ])),
              ],
            ),
          );
        },
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
        Tab(
          text: "Hoá đơn",
          icon: Icon(Icons.receipt_long),
        ),
      ];
      return Container(
        child: DefaultTabController(
          length: listPaymentTab.length,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: Get.theme.colorScheme.primary,
                tabs: listPaymentTab,
                onTap: (value) {
                  debugPrint("value: $value");
                  // if (value == 0) {
                  //   model.handleChangeFilterProductByCategory(null);
                  // } else {
                  //   model.handleChangeFilterProductByCategory(
                  //       model.currentMenu?.categories![value - 1].id);
                  // }
                },
              ),
              SizedBox(
                height: 8,
              ),
              Expanded(
                  child: TabBarView(
                children: [
                  paymentTypeSelect(model),
                  cusstomerInfoSelect(model),
                  promotionTypeSelect(model),
                  BillScreen(),
                ],
              ))
            ],
          ),
        ),
      );
    }),
  );
}

Widget paymentTypeSelect(OrderViewModel model) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.onInverseSurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Phuơng thức"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.money_rounded, size: 40),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "Tiền mặt",
                                  style: Get.textTheme.titleMedium,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.credit_card, size: 40),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "VNPay",
                                  style: Get.textTheme.titleMedium,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.wallet, size: 40),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  "MoMo",
                                  style: Get.textTheme.titleMedium,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )),
      Expanded(
          flex: 2,
          child: Container(
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Tièn khách trả"),
                  ),
                ],
              ))),
    ],
  );
}

Widget cusstomerInfoSelect(OrderViewModel model) {
  return Container(child: Text("Khach hang"));
}

Widget promotionTypeSelect(OrderViewModel model) {
  return Container(child: Text("Khuyến mãi"));
}

Widget checkoutPayment(OrderViewModel model) {
  return Container(
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.onInverseSurface,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
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
                  child: Expanded(
                    child: Text(
                      'Thông tin thanh toán',
                      style: Get.textTheme.titleMedium,
                    ),
                  ),
                ),
                Divider(
                  color: Get.theme.colorScheme.onSurface,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Mã đơn',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        model.orderResponseModel!.invoiceId!,
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Bàn',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        model.selectedTable.toString(),
                        style: Get.textTheme.bodyMedium,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Khách hàng',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        'User',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thanh toán',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        model.orderResponseModel!.payment!.paymentType!,
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thời gian',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        formatTime(model.orderResponseModel!.checkInDate!),
                        style: Get.textTheme.bodyMedium,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tạm tính',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        formatPrice(model.orderResponseModel!.totalAmount!),
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Giảm giá',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        " - ${formatPrice(model.orderResponseModel!.discount!)}",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '%VAT',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        '${model.orderResponseModel!.vat! * 100} %',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'VAT',
                        style: Get.textTheme.bodyMedium,
                      ),
                      Text(
                        formatPrice(model.orderResponseModel!.vatAmount!),
                        style: Get.textTheme.bodyMedium,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Tổng tiền',
                        style: Get.textTheme.titleMedium,
                      ),
                      Text(
                        formatPrice(model.orderResponseModel!.finalAmount!),
                        style: Get.textTheme.titleMedium,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Khách đưa',
                        style: Get.textTheme.titleMedium,
                      ),
                      Text(
                        formatPrice(model.orderResponseModel!.finalAmount!),
                        style: Get.textTheme.titleMedium,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Trả lại',
                        style: Get.textTheme.titleMedium,
                      ),
                      Text(
                        formatPrice(model.orderResponseModel!.finalAmount!),
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 140,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => {},
                      icon: Icon(Icons.cancel_outlined),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Huỷ đơn hàng',
                          style: Get.textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Get.theme.colorScheme.onSurface,
                  thickness: 1,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => {null},
                      icon: Icon(Icons.check),
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Hoan thành',
                          style: Get.textTheme.titleMedium?.copyWith(
                              color: Get.theme.colorScheme.background),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

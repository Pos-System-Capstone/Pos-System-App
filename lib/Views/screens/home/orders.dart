import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/Widgets/Dialogs/payment_dialogs/payment_dialog.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../enums/order_enum.dart';
import '../../../enums/view_status.dart';
import '../../../widgets/Dialogs/other_dialogs/dialog.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  bool isToday = true;
  bool isYesterday = false;
  int page = 1;
  @override
  initState() {
    orderViewModel.getListOrder(
        isToday: isToday, isYesterday: isYesterday, page: page);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: orderViewModel,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ScopedModelDescendant<OrderViewModel>(
              builder: (context, child, model) {
            if (model.status == ViewStatus.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(isToday
                                  ? Get.theme.colorScheme.surfaceVariant
                                  : Get.theme.colorScheme.background)),
                          onPressed: () => {
                                setState(() {
                                  isToday = true;
                                  isYesterday = false;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page)
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Hôm nay"),
                          )),
                      SizedBox(width: 8),
                      OutlinedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  isYesterday
                                      ? Get.theme.colorScheme.surfaceVariant
                                      : Get.theme.colorScheme.background)),
                          onPressed: () => {
                                setState(() {
                                  isToday = false;
                                  isYesterday = true;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page)
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Hôm qua"),
                          )),
                      Spacer(),
                      Text(
                        "Trang:",
                        style: Get.textTheme.titleMedium,
                      ),
                      for (var i = 1; i < 6; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: OutlinedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      page == i
                                          ? Get.theme.colorScheme.surfaceVariant
                                          : Get.theme.colorScheme.background)),
                              onPressed: () => {
                                    setState(() {
                                      page = i;
                                    }),
                                    model.getListOrder(
                                        isToday: isToday,
                                        isYesterday: isYesterday,
                                        page: page)
                                  },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Text(i.toString()),
                              )),
                        )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: model.listOrder.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () => {
                              if (model.listOrder[index].status ==
                                  OrderStatusEnum.PAID)
                                {
                                  orderInfoDialog(
                                      model.listOrder[index].id ?? "")
                                }
                              else
                                {
                                  showPaymentBotomSheet(
                                      model.listOrder[index].id!),
                                }
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.receipt_long_outlined),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                model.listOrder[index].invoiceId
                                                    .toString(),
                                                style:
                                                    Get.textTheme.titleSmall),
                                            Text(
                                              formatTime(model.listOrder[index]
                                                      .endDate ??
                                                  DateTime.now().toString()),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Nhân viên: ${model.listOrder[index].staffName}",
                                                style:
                                                    Get.textTheme.titleSmall),
                                            Text(
                                                showOrderStatus(model
                                                        .listOrder[index]
                                                        .status ??
                                                    ''),
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "Thanh toán: ${formatPrice(model.listOrder[index].finalAmount ?? 0)}",
                                                style:
                                                    Get.textTheme.titleSmall),
                                            Text(
                                                showOrderType(model
                                                            .listOrder[index]
                                                            .orderType ??
                                                        '')
                                                    .label,
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: Get
                                                            .theme
                                                            .colorScheme
                                                            .primary)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

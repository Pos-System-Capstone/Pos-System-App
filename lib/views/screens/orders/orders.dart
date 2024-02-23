import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../enums/order_enum.dart';
import '../../../enums/view_status.dart';
import '../home/payment/payment_dialogs/payment_dialog.dart';
import 'dialogs/order_info_dailog.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  TextEditingController orderController = TextEditingController();
  bool isToday = true;
  bool isYesterday = false;
  int page = 1;
  @override
  initState() {
    orderViewModel.getListOrder(
        isToday: isToday, isYesterday: isYesterday, page: page);
    super.initState();
  }

  fetchOrder() {
    orderViewModel.getListOrder(
        isToday: isToday, isYesterday: isYesterday, page: page);
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
                  height: 40,
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
                          child: Text("Hôm nay")),
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
                          child: Text("Hôm qua")),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: TextField(
                        controller: orderController,
                        decoration: InputDecoration(
                            hintText: "Quét mã để tìm đơn hàng",
                            hintStyle: Get.textTheme.bodyMedium,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            filled: true,
                            isDense: true,
                            labelStyle: Get.textTheme.labelLarge,
                            fillColor: Get.theme.colorScheme.background,
                            prefixIcon: Icon(
                              Icons.portrait_rounded,
                              color: Get.theme.colorScheme.onBackground,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  orderController.clear();
                                },
                                icon: Icon(
                                  Icons.clear,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color:
                                        Get.theme.colorScheme.primaryContainer,
                                    width: 2.0)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color:
                                        Get.theme.colorScheme.primaryContainer,
                                    width: 2.0)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color:
                                        Get.theme.colorScheme.primaryContainer,
                                    width: 2.0)),
                            contentPadding: EdgeInsets.all(16),
                            isCollapsed: true,
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Get.theme.colorScheme.error,
                                    width: 2.0))),
                      )),
                      SizedBox(
                        width: 4,
                      ),
                      FilledButton(
                          onPressed: () => {
                                if (orderController.text.isNotEmpty)
                                  {orderInfoDialog(orderController.text)}
                              },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Kiểm tra"),
                          )),
                      SizedBox(
                        width: 8,
                      ),
                      IconButton(
                          onPressed: () => {
                                fetchOrder(),
                              },
                          icon: Icon(Icons.replay_outlined)),
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
                              color: model.listOrder[index].customerName != null
                                  ? Get.theme.colorScheme.outlineVariant
                                  : Get.theme.colorScheme.background,
                              padding: EdgeInsets.only(left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                showOrderStatus(model
                                                        .listOrder[index]
                                                        .status ??
                                                    ''),
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: model
                                                                    .listOrder[
                                                                        index]
                                                                    .status ==
                                                                OrderStatusEnum
                                                                    .PENDING
                                                            ? Get
                                                                .theme
                                                                .colorScheme
                                                                .primary
                                                            : model
                                                                        .listOrder[
                                                                            index]
                                                                        .status ==
                                                                    OrderStatusEnum
                                                                        .PAID
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              formatTime(model.listOrder[index]
                                                      .endDate ??
                                                  DateTime.now().toString()),
                                            ),
                                            Text(
                                                "${model.getPaymentName(model.listOrder[index].paymentType ?? 'CASH')} (${formatPrice(model.listOrder[index].finalAmount ?? 0)})",
                                                style:
                                                    Get.textTheme.titleSmall),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                model.listOrder[index]
                                                        .staffName ??
                                                    '',
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                model.listOrder[index]
                                                            .customerName !=
                                                        null
                                                    ? "Khách hàng: ${model.listOrder[index].customerName} , ${model.listOrder[index].phone?.replaceFirst("+84", "0")} "
                                                    : "",
                                                style:
                                                    Get.textTheme.titleSmall),
                                            Text(
                                                model.listOrder[index]
                                                            .customerName !=
                                                        null
                                                    ? showPaymentStatusEnum(
                                                        model.listOrder[index]
                                                                .paymentStatus ??
                                                            '',
                                                      )
                                                    : "",
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: model
                                                                    .listOrder[
                                                                        index]
                                                                    .paymentStatus ==
                                                                PaymentStatusEnum
                                                                    .PENDING
                                                            ? Get
                                                                .theme
                                                                .colorScheme
                                                                .primary
                                                            : model
                                                                        .listOrder[
                                                                            index]
                                                                        .paymentStatus ==
                                                                    PaymentStatusEnum
                                                                        .PAID
                                                                ? Colors
                                                                    .greenAccent
                                                                : Colors
                                                                    .redAccent)),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Trang:",
                          style: Get.textTheme.titleMedium,
                        ),
                        for (var i = 1; i < 7; i++)
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        page == i
                                            ? Get.theme.colorScheme
                                                .surfaceVariant
                                            : Get
                                                .theme.colorScheme.background)),
                                onPressed: () => {
                                      setState(() {
                                        page = i;
                                      }),
                                      model.getListOrder(
                                          isToday: isToday,
                                          isYesterday: isYesterday,
                                          page: page)
                                    },
                                child: Text(i.toString())),
                          )
                      ],
                    ),
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

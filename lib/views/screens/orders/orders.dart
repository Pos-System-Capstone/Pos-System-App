import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../data/model/response/order_in_list.dart';
import '../../../enums/order_enum.dart';
import '../../../enums/view_status.dart';
import '../../../helper/responsive_helper.dart';
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
  String? invoice;
  String? status;
  String? payment;
  String? type;
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    isToday
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
                                      page: page,
                                      orderStatus: status,
                                      paymentType: payment)
                                },
                            child: Text("Hôm nay")),
                        TextButton(
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
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    payment == PaymentTypeEnums.CASH
                                        ? Get.theme.colorScheme.surfaceVariant
                                        : Get.theme.colorScheme.background)),
                            onPressed: () => {
                                  setState(() {
                                    payment = PaymentTypeEnums.CASH;
                                  }),
                                  model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    paymentType: payment,
                                    orderStatus: status,
                                  )
                                },
                            child: Text("Tiền mặt")),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    payment == PaymentTypeEnums.BANKING
                                        ? Get.theme.colorScheme.surfaceVariant
                                        : Get.theme.colorScheme.background)),
                            onPressed: () => {
                                  setState(() {
                                    payment = PaymentTypeEnums.BANKING;
                                  }),
                                  model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    paymentType: payment,
                                    orderStatus: status,
                                  )
                                },
                            child: Text("Ngân hàng")),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    payment == PaymentTypeEnums.MOMO
                                        ? Get.theme.colorScheme.surfaceVariant
                                        : Get.theme.colorScheme.background)),
                            onPressed: () => {
                                  setState(() {
                                    payment = PaymentTypeEnums.MOMO;
                                  }),
                                  model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    paymentType: payment,
                                    orderStatus: status,
                                  )
                                },
                            child: Text("MOMO")),
                        TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    payment == PaymentTypeEnums.POINTIFY
                                        ? Get.theme.colorScheme.surfaceVariant
                                        : Get.theme.colorScheme.background)),
                            onPressed: () => {
                                  setState(() {
                                    payment = PaymentTypeEnums.POINTIFY;
                                  }),
                                  model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    paymentType: payment,
                                    orderStatus: status,
                                  )
                                },
                            child: Text("POINTIFY")),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: orderController,
                            decoration: InputDecoration(
                                hintText: "Quét mã để tìm đơn hàng",
                                hintStyle: Get.textTheme.bodyMedium,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                filled: true,
                                isDense: true,
                                labelStyle: Get.textTheme.labelLarge,
                                fillColor: Get.theme.colorScheme.background,
                                prefixIcon: Icon(
                                  Icons.portrait_rounded,
                                  color: Get.theme.colorScheme.onBackground,
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () => {
                                          orderController.clear(),
                                          setState(() {
                                            invoice = null;
                                          }),
                                          model.getListOrder(
                                              isToday: isToday,
                                              isYesterday: isYesterday,
                                              page: page,
                                              orderStatus: status,
                                              paymentType: payment,
                                              invoiceId: null)
                                        },
                                    icon: Icon(
                                      Icons.clear,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get
                                            .theme.colorScheme.primaryContainer,
                                        width: 2.0)),
                                contentPadding: EdgeInsets.all(16),
                                isCollapsed: true,
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                        color: Get.theme.colorScheme.error,
                                        width: 2.0))),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        IconButton.filled(
                          onPressed: () => {
                            if (orderController.text.isNotEmpty)
                              {
                                setState(() {
                                  invoice = orderController.text;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    orderStatus: status,
                                    paymentType: payment,
                                    invoiceId: invoice == "" ? null : invoice)
                              }
                          },
                          icon: Icon(Icons.search),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        IconButton(
                            onPressed: () => {
                                  setState(() {
                                    status = null;
                                    payment = null;
                                    invoice = null;
                                  }),
                                  fetchOrder(),
                                },
                            icon: Icon(Icons.replay_outlined)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.count(
                        scrollDirection: Axis.vertical,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
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
                          for (int i = 0; i < model.listOrder.length; i++)
                            orderCard(model, model.listOrder[i])
                        ]),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                              child: Text(i.toString())),
                        ),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  status == OrderStatusEnum.PAID
                                      ? Get.theme.colorScheme.surfaceVariant
                                      : Get.theme.colorScheme.background)),
                          onPressed: () => {
                                setState(() {
                                  status = OrderStatusEnum.PAID;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    orderStatus: status)
                              },
                          child: Text(showOrderStatus(OrderStatusEnum.PAID),
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.teal))),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  status == OrderStatusEnum.PENDING
                                      ? Get.theme.colorScheme.surfaceVariant
                                      : Get.theme.colorScheme.background)),
                          onPressed: () => {
                                setState(() {
                                  status = OrderStatusEnum.PENDING;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    orderStatus: status)
                              },
                          child: Text(showOrderStatus(OrderStatusEnum.PENDING),
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.orange))),
                      TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  status == OrderStatusEnum.NEW
                                      ? Get.theme.colorScheme.surfaceVariant
                                      : Get.theme.colorScheme.background)),
                          onPressed: () => {
                                setState(() {
                                  status = OrderStatusEnum.NEW;
                                }),
                                model.getListOrder(
                                    isToday: isToday,
                                    isYesterday: isYesterday,
                                    page: page,
                                    orderStatus: status)
                              },
                          child: Text(showOrderStatus(OrderStatusEnum.NEW),
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey))),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget orderCard(OrderViewModel model, OrderInList order) {
    return InkWell(
      onTap: () => {
        if (order.status == OrderStatusEnum.PAID ||
            order.status == OrderStatusEnum.CANCELED)
          {orderInfoDialog(order.id ?? "")}
        else if (order.status == OrderStatusEnum.NEW)
          {
            showConfirmDialog(
                    title: "Có đơn hàng chờ xác nhận",
                    content:
                        "Để xác nhận đơn hàng vui lòng bấm vào nút nhận đơn \n Để huỷ đơn vui lòng bấm nút huỷ",
                    confirmText: "Nhận đơn",
                    cancelText: "Huỷ đơn")
                .then((value) => {
                      if (value)
                        {
                          model.confirmOrder(
                              OrderStatusEnum.PENDING, order.id ?? '')
                        }
                      else
                        {
                          model.confirmOrder(
                              OrderStatusEnum.CANCELED, order.id ?? '')
                        }
                    })
          }
        else
          {
            showPaymentBotomSheet(order.id!),
          }
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.invoiceId.toString(), style: Get.textTheme.bodyMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(showOrderStatus(order.status ?? ''),
                    style: Get.textTheme.titleSmall?.copyWith(
                        color: order.status == OrderStatusEnum.NEW
                            ? Get.theme.colorScheme.secondary
                            : order.status == OrderStatusEnum.PENDING
                                ? Get.theme.colorScheme.primary
                                : order.status == OrderStatusEnum.PAID
                                    ? Colors.teal
                                    : Colors.red)),
                Text(showOrderType(order.orderType ?? '').label,
                    style: Get.textTheme.titleSmall
                        ?.copyWith(color: Get.theme.colorScheme.primary)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  formatTime(order.endDate ?? DateTime.now().toString()),
                ),
                Text(
                    "${model.getPaymentName(order.paymentType ?? 'CASH')} (${formatPrice(order.finalAmount ?? 0)})",
                    style: Get.textTheme.titleSmall),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    order.customerName != null
                        ? "KH: ${order.customerName}"
                        : "",
                    style: Get.textTheme.bodyMedium),
                Text(
                    order.phone != null
                        ? " | SDT:${order.phone?.replaceFirst("+84", "0")}"
                        : "",
                    style: Get.textTheme.bodyMedium),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(order.deliTime != null ? "TG giao: ${order.deliTime}" : "",
                    style: Get.textTheme.bodyMedium),
                Text(
                    order.address != null ? " | Địa chỉ: ${order.address}" : "",
                    style: Get.textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

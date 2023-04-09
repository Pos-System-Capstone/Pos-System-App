import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../view_model/order_view_model.dart';
import '../Dialogs/payment_dialogs/payment_dialog.dart';
import '../orders/bill_screen.dart';

class PaymentScreen extends StatefulWidget {
  String orderId;
  PaymentScreen(this.orderId, {super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  @override
  void initState() {
    orderViewModel.getOrderByStore(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.colorScheme.background,
      child: ScopedModel(
          model: Get.find<OrderViewModel>(),
          child: Column(
            children: [
              ScopedModelDescendant<OrderViewModel>(
                  builder: (context, build, model) {
                if (model.status == ViewStatus.Loading ||
                    model.currentOrder == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Đơn hàng: ${model.currentOrder?.invoiceId ?? ""}",
                          style: Get.textTheme.titleMedium),
                      IconButton(
                          onPressed: () {
                            model.clearOrder();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 32,
                          )),
                    ],
                  ),
                );
              }),
              Expanded(
                child: Get.context!.isPortrait
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
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
              ),
            ],
          )),
    );
  }
}

Widget orderConfig() {
  List<Tab>? listPaymentTab = [
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.payment),
          SizedBox(width: 8),
          Text("Thanh toán"),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.person),
          SizedBox(width: 8),
          Text("Khách hàng"),
        ],
      ),
    ),
    Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(Icons.local_offer),
          SizedBox(width: 8),
          Text("Khuyến mãi"),
        ],
      ),
    ),
    // Tab(
    //   text: "Đơn hàng",
    //   icon: Icon(Icons.receipt),
    // ),
  ];
  return ScopedModelDescendant<OrderViewModel>(
      builder: (context, build, model) {
    if (model.status == ViewStatus.Loading || model.currentOrder == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
  });
}

Widget paymentTypeSelect(OrderViewModel model) {
  return Container(
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
                          if (e.name != "Tiền mặt") {
                            scanQRCodeDialog(
                                e.name == "Momo"
                                    ? "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2FIMG_0428.jpeg?alt=media&token=ffac0e03-9083-4f65-aeaa-0ecb2e8aad91"
                                    : e.name == "VN PAY"
                                        ? "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2FIMG_0429.jpeg?alt=media&token=c222ea8e-65a0-4be6-b973-2f2b3b3ef87a"
                                        : "",
                                e.name ?? "");
                          }
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
      ],
    ),
  );
}

Widget customerInfoSelect(OrderViewModel model) {
  return Container(child: Text("Khach hang"));
}

Widget promotionTypeSelect(OrderViewModel model) {
  return Container(child: Text("Khuyến mãi"));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../view_model/index.dart';
import 'bill_screen.dart';

class PaymentScreen extends StatefulWidget {
  String orderId;
  PaymentScreen(this.orderId, {super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  bool isQrCodeOpen = false;
  @override
  void initState() {
    orderViewModel.getOrderByStore(widget.orderId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
          model: Get.find<OrderViewModel>(),
          child: Column(
            children: [
              SizedBox(height: 16),
              ScopedModelDescendant<OrderViewModel>(
                  builder: (context, build, model) {
                if (model.status == ViewStatus.Loading ||
                    model.currentOrder == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(model.currentOrder?.invoiceId ?? "",
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
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: double.infinity,
                                height: Get.height * 0.8,
                                child: orderConfig()),
                            SizedBox(
                                width: Get.width,
                                height: Get.height * 0.6,
                                child: BillScreen())
                          ],
                        ),
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
    // Tab(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: const [
    //       Icon(Icons.person),
    //       SizedBox(width: 8),
    //       Text("Khách hàng"),
    //     ],
    //   ),
    // ),
    // Tab(
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: const [
    //       Icon(Icons.local_offer),
    //       SizedBox(width: 8),
    //       Text("Khuyến mãi"),
    //     ],
    //   ),
    // ),
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
              paymentTypeSelect(),
              // customerInfoSelect(model),
              // promotionTypeSelect(model),
              // BillScreen(),
            ],
          ))
        ],
      ),
    );
  });
}

Widget paymentTypeSelect() {
  return ScopedModelDescendant<OrderViewModel>(
      builder: (context, build, model) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          model.qrCodeData != null
              ? Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(16),
                  child: PrettyQr(
                    image: NetworkImage(
                      model.selectedPaymentMethod?.picUrl ?? "",
                    ),
                    typeNumber: null,
                    size: 300,
                    elementColor: Colors.black,
                    data: model.qrCodeData!,
                    errorCorrectLevel: QrErrorCorrectLevel.M,
                    roundEdges: true,
                  ),
                )
              : SizedBox(),
          model.listPayment.isEmpty
              ? Expanded(
                  child: Center(
                  child: Text("Phương thức thanh toán mặc định là tiền mặt",
                      style: Get.textTheme.titleMedium),
                ))
              : Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                                        ? Get.theme.colorScheme.primaryContainer
                                        : Get.theme.colorScheme.background,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Image.network(
                                            e!.picUrl!,
                                            width: 80,
                                            height: 80,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: Text(
                                              e.name!,
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
                ),
          Text(
            "Trạng thái: ${model.currentPaymentStatusMessage}",
            style: Get.textTheme.titleMedium,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: () {
                      model.makePayment(model.selectedPaymentMethod!);
                    },
                    child: Text("Thực hiện thanh toán"),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    height: 80,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (model.paymentCheckingStatus ==
                                PaymentStatusEnum.CANCELED &&
                            model.selectedPaymentMethod != null) {
                          model
                              .checkPaymentStatus(model.currentOrder!.orderId!);
                        } else if (model.selectedPaymentMethod == null) {
                          Get.snackbar(
                              "Lỗi", "Vui lòng tiền hành thanh toán trước");
                        } else {
                          null;
                        }
                      },
                      label: model.paymentCheckingStatus ==
                              PaymentStatusEnum.PENDING
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Đang kiểm tra...',
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const CircularProgressIndicator(),
                              ],
                            )
                          : model.paymentCheckingStatus ==
                                  PaymentStatusEnum.PAID
                              ? Text('Thanh toán thành công')
                              : model.paymentCheckingStatus ==
                                      PaymentStatusEnum.FAIL
                                  ? Text('Thanh toán thất bại')
                                  : Text('Kiểm tra thanh toán'),
                      icon: model.paymentCheckingStatus ==
                              PaymentStatusEnum.PENDING
                          ? Icon(CupertinoIcons.refresh_circled)
                          : model.paymentCheckingStatus ==
                                  PaymentStatusEnum.PAID
                              ? Icon(CupertinoIcons.check_mark_circled)
                              : model.paymentCheckingStatus ==
                                      PaymentStatusEnum.FAIL
                                  ? Icon(CupertinoIcons.xmark_circle)
                                  : Icon(CupertinoIcons.search_circle),
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  });
}

Widget customerInfoSelect(OrderViewModel model) {
  return Text("Khach hang");
}

Widget promotionTypeSelect(OrderViewModel model) {
  return Text("Khuyến mãi");
}

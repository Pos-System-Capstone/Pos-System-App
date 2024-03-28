import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/views/screens/home/payment/payment_dialogs/input_customer_monney_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../view_model/index.dart';
import 'bill_screen.dart';
import 'payment_dialogs/payment_dialog.dart';

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
    return ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: BorderRadius.circular(8),
          ),
          width: Get.width * 0.9,
          height: Get.height * 0.8,
          child: Column(
            children: [
              Expanded(
                child: Get.context!.isPortrait
                    ? SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                height: Get.height * 0.9,
                                child: paymentTypeSelect()),
                            Container(
                                padding: EdgeInsets.all(8),
                                width: double.infinity,
                                height: Get.height,
                                child: BillScreen()),
                          ],
                        ),
                      )
                    : Row(children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: paymentTypeSelect(),
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
          ),
        ));
  }
}

Widget paymentTypeSelect() {
  return ScopedModelDescendant<OrderViewModel>(
      builder: (context, build, model) {
    if (model.status == ViewStatus.Loading || model.currentOrder == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.onInverseSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text("Phương thức thanh toán", style: Get.textTheme.titleLarge),
          ),
          Divider(
            thickness: 1,
            color: Get.theme.colorScheme.onBackground,
          ),
          model.listPayment.isEmpty
              ? Expanded(
                  child: Center(
                  child: Text("Phương thức thanh toán mặc định là tiền mặt",
                      style: Get.textTheme.titleMedium),
                ))
              : Expanded(
                  child: GridView.count(
                    crossAxisCount: 4,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    children: model.listPayment
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              if (model.paymentCheckingStatus ==
                                  PaymentStatusEnum.PAID) {
                                return;
                              }
                              if (e.type == PaymentTypeEnums.CASH) {
                                num money = await inputMonneyDialog();
                                model.setCustomerMoney(money);
                              } else {
                                model.setCustomerMoney(0);
                              }
                              model.selectPayment(e);
                            },
                            child: Card(
                              color: model.selectedPaymentMethod == e
                                  ? Get.theme.colorScheme.primaryContainer
                                  : Get.theme.colorScheme.background,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      e!.picUrl,
                                      width: 80,
                                      height: 80,
                                    ),
                                    Text(
                                      e.name,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
          Text(
            "Trạng thái: ${showPaymentStatusEnum(model.paymentCheckingStatus)}",
            style: Get.textTheme.titleMedium,
          ),
          SizedBox(
            height: 8,
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
                        if (model.selectedPaymentMethod == null) {
                          Get.snackbar(
                              "Lỗi", "Vui lòng chọn phương thức thanh toán");
                        } else {
                          model.makePayment(model.selectedPaymentMethod!);
                        }
                      },
                      child:
                          model.paymentCheckingStatus == PaymentStatusEnum.PAID
                              ? Text(
                                  "Hoàn thành (Đơn hàng đã thanh toán)",
                                )
                              : Text("Thanh toán")),
                ),
              ),
              Container(
                  height: 80,
                  padding: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      num money = await inputMonneyDialog();
                      model.setCustomerMoney(money);
                    },
                    child: Text("Nhập tiền khách đưa"),
                  )),
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

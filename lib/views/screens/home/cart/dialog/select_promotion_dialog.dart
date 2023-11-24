import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/pointify/promotion_model.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../../data/model/response/promotion.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/cart/promotion.dart';
import '../../../../widgets/other_dialogs/dialog.dart';
import '../../payment/payment_dialogs/input_customer_monney_dialog.dart';

void selectPromotionDialog() {
  Get.dialog(
    PormotionDialog(),
  );
}

class PormotionDialog extends StatefulWidget {
  const PormotionDialog({super.key});

  @override
  State<PormotionDialog> createState() => _PormotionDialogState();
}

class _PormotionDialogState extends State<PormotionDialog> {
  CartViewModel cartViewModel = Get.find<CartViewModel>();
  OrderViewModel orderViewModel = Get.find<OrderViewModel>();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    cartViewModel.getListPromotion();
    phoneController.text = cartViewModel.customer?.phoneNumber ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Scaffold(
            appBar: TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.discount),
                  text: "Khuyến mãi",
                ),
                Tab(
                  icon: Icon(Icons.wallet_membership),
                  text: "Thành viên",
                ),
                Tab(
                  icon: Icon(Icons.payment),
                  text: "Thanh toán",
                ),
              ],
            ),
            body: TabBarView(
              children: [
                PromotionSelectWidget(),
                ScopedModel<CartViewModel>(
                  model: cartViewModel,
                  child: ScopedModelDescendant<CartViewModel>(
                      builder: (context, build, model) {
                    return Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextField(
                                keyboardType: TextInputType.number,
                                controller: phoneController,
                                decoration: InputDecoration(
                                    hintText: "Nhập số điện thoại",
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
                                      onPressed: () {
                                        phoneController.clear();
                                        model.removeCustomer();
                                      },
                                      icon: Icon(Icons.clear),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Get.theme.colorScheme
                                                .primaryContainer,
                                            width: 2.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Get.theme.colorScheme
                                                .primaryContainer,
                                            width: 2.0)),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Get.theme.colorScheme
                                                .primaryContainer,
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
                                width: 16,
                              ),
                              OutlinedButton(
                                  onPressed: () => {
                                        model.scanCustomer(phoneController.text)
                                      },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Tìm"),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Center(child: userCard(model))
                        ],
                      ),
                    ));
                  }),
                ),
                ScopedModel<OrderViewModel>(
                  model: orderViewModel,
                  child: ScopedModelDescendant<OrderViewModel>(
                      builder: (context, build, model) {
                    return SingleChildScrollView(
                      child: Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.center,
                          children: model.listPayment
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: InkWell(
                                    onTap: () async {
                                      // if (e.type == PaymentTypeEnums.CASH) {
                                      //   num money = await inputMonneyDialog();
                                      //   model.setCustomerMoney(money);
                                      // } else {
                                      //   model.setCustomerMoney(0);
                                      // }
                                      model.selectPayment(e);
                                    },
                                    child: Card(
                                      color: model.selectedPaymentMethod == e
                                          ? Get.theme.colorScheme
                                              .primaryContainer
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
                    );
                  }),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                      onPressed: () async {
                        await Get.find<CartViewModel>().prepareOrder();
                        hideDialog();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Kiểm tra"),
                      )),
                  OutlinedButton(
                    onPressed: () {
                      hideDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Đóng"),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget userCard(CartViewModel model) {
    if (model.customer == null) {
      return Center(
        child: Text("Vui lòng nhập số điện thoại"),
      );
    }
    if (model.status == ViewStatus.Loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container(
      padding: EdgeInsets.all(16),
      width: Get.width * 0.8,
      height: 200,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Tên"), Text(model.customer?.fullName ?? '')],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Số điện thoại"),
                Text(
                    model.customer!.phoneNumber!.replaceFirst("+84", '0') ?? "")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text("Email"), Text(model.customer?.email ?? '')],
            )
          ]),
    );
  }
}

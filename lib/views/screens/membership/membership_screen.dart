import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/membership/topup_dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../enums/view_status.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController topupController = TextEditingController();
  String popupPaymentType = PaymentTypeEnums.CASH;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<OrderViewModel>(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, build, model) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      decoration: InputDecoration(
                          hintText: "Nhập số điện thoại hoặc quét mã",
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
                                phoneController.clear();
                                model.removeMembership();
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 32,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Get.theme.colorScheme.primaryContainer,
                                  width: 2.0)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Get.theme.colorScheme.primaryContainer,
                                  width: 2.0)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: Get.theme.colorScheme.primaryContainer,
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
                    FilledButton(
                        onPressed: () =>
                            {model.scanMembership(phoneController.text)},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Kiểm tra"),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Center(child: userCard(model)),
              SizedBox(
                height: 32,
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
                      topupUserWalletDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text("Nạp tiền"),
                    )),
                OutlinedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text("Đóng"),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget userCard(OrderViewModel model) {
    if (model.memberShipInfo == null) {
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
              children: [
                Text("Tên"),
                Text(model.memberShipInfo?.fullName ?? '')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Số điện thoại"),
                Text(model.memberShipInfo!.phoneNumber!
                        .replaceFirst("+84", '0') ??
                    "")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Email"),
                Text(model.memberShipInfo?.email ?? '')
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  keyboardType: TextInputType.number,
                  controller: topupController,
                  decoration: InputDecoration(
                      hintText: "Nhập số tiền cần nạp",
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
                            phoneController.clear();
                            model.removeMembership();
                          },
                          icon: Icon(
                            Icons.clear,
                            size: 32,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Get.theme.colorScheme.primaryContainer,
                              width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Get.theme.colorScheme.primaryContainer,
                              width: 2.0)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Get.theme.colorScheme.primaryContainer,
                              width: 2.0)),
                      contentPadding: EdgeInsets.all(16),
                      isCollapsed: true,
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Get.theme.colorScheme.error, width: 2.0))),
                )),
                SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            model.topupPaymentType == PaymentTypeEnums.CASH
                                ? Get.theme.colorScheme.surfaceVariant
                                : Get.theme.colorScheme.background)),
                    onPressed: () {
                      model.setTopUpType(PaymentTypeEnums.CASH);
                    },
                    child: Text("Tiền mặt")),
                SizedBox(
                  width: 8,
                ),
                OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            model.topupPaymentType == PaymentTypeEnums.BANKING
                                ? Get.theme.colorScheme.surfaceVariant
                                : Get.theme.colorScheme.background)),
                    onPressed: () {
                      model.setTopUpType(PaymentTypeEnums.BANKING);
                    },
                    child: Text("Chuyển khoản")),
                SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () =>
                        {model.topupWallet(num.parse(topupController.text))},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Nạp"),
                    )),
              ],
            ),
          ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../enums/view_status.dart';
import '../../../view_model/cart_view_model.dart';

class MembershipWidget extends StatefulWidget {
  const MembershipWidget({super.key});

  @override
  State<MembershipWidget> createState() => _MembershipWidgetState();
}

class _MembershipWidgetState extends State<MembershipWidget> {
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    phoneController.text =
        Get.find<CartViewModel>().customer?.phoneNumber ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartViewModel>(
      model: Get.find<CartViewModel>(),
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
                              model.removeCustomer();
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
                          {model.scanCustomer(phoneController.text)},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Kiểm tra"),
                      )),
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

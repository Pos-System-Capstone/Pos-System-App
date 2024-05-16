import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/model/pointify/promotion_model.dart';
import '../../../view_model/cart_view_model.dart';
import '../other_dialogs/dialog.dart';

class PromotionSelectWidget extends StatefulWidget {
  const PromotionSelectWidget({super.key});

  @override
  State<PromotionSelectWidget> createState() => _PromotionSelectWidgetState();
}

class _PromotionSelectWidgetState extends State<PromotionSelectWidget> {
  TextEditingController voucherController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartViewModel>(
      model: Get.find<CartViewModel>(),
      child: ScopedModelDescendant<CartViewModel>(
          builder: (context, build, model) {
        if (model.status == ViewStatus.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (model.promotions == null || model.promotions == []) {
          return Center(
            child: Text("Hiên không có khuyến mãi cho cửa hàng này"),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: TextField(
                    controller: voucherController,
                    decoration: InputDecoration(
                        hintText: "Nhập mã giảm giá hoặc quét mã",
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
                            voucherController.clear();
                            model.removeVoucher();
                          },
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 32,
                          ),
                        ),
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
                    width: 8,
                  ),
                  FilledButton(
                      onPressed: () =>
                          {model.selectVoucher(voucherController.text)},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Kiểm tra"),
                      )),
                  SizedBox(
                    width: 16,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Thông tin thành viên",
                  style: Get.textTheme.titleMedium,
                ),
              ),
              userCard(model),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Danh sánh khuyến mãi khả dụng",
                  style: Get.textTheme.titleMedium,
                ),
              ),
              Wrap(
                children: [
                  for (PromotionPointify item in model.promotions!
                      .where((element) => element.promotionType == 2)
                      .toList())
                    InkWell(
                      onTap: () {
                        if (model.isPromotionApplied(item.promotionCode)) {
                          model.removePromotion();
                        } else if (item.promotionType == 1) {
                          showAlertDialog(
                              content:
                                  "Khuyến mãi sẽ tự động áp dụng nếu đủ điều kiện");
                        } else if (item.promotionType == 3) {
                          showAlertDialog(
                              content:
                                  "Khuyến mãi cần có mã để được áp dụng, vui lòng quét mã để sử dụng");
                        } else {
                          model.selectPromotion(item.promotionCode);
                        }

                        // }
                      },
                      child: Card(
                        color: model.isPromotionApplied(item.promotionCode)
                            ? Get.theme.colorScheme.primaryContainer
                            : Get.theme.colorScheme.background,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          width: GetPlatform.isMobile ? Get.width : 200,
                          height: 140,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                item.promotionName,
                                style: Get.textTheme.labelLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              Divider(),
                              Text(
                                item.description ?? '',
                                style: Get.textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
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
    padding: EdgeInsets.all(8),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
              Text(model.customer!.phoneNumber!.replaceFirst("+84", '0') ?? "")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Điểm"),
              Text(formatPrice((model.customer!.point ?? 0)))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Số dư ví"),
              Text(formatPrice((model.customer!.balance ?? 0)))
            ],
          )
        ]),
  );
}

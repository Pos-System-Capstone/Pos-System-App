import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/model/response/sessions.dart';
import '../../../enums/index.dart';
import '../../../view_model/menu_view_model.dart';

Future<bool> showAlertDialog(
    {String title = "Thông báo",
    String content = "Nội dung thông báo",
    String confirmText = "Đồng ý"}) async {
  hideDialog();
  bool result = false;
  await Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: Get.size.width * 0.3,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Get.textTheme.titleLarge,
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                content,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  result = false;
                  hideDialog();
                },
                child: Text(
                  confirmText,
                  style: Get.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ));
  return result;
}

Future<bool> showConfirmDialog(
    {String title = "Xác nhận",
    String content = "Bạn có chắc chắn muốn thực hiện thao tác này?",
    String confirmText = "Xác nhận",
    String cancelText = "Hủy"}) async {
  hideDialog();
  bool result = false;
  await Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: Get.size.width * 0.5,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: Get.textTheme.titleLarge,
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                content,
                style: Get.textTheme.bodyLarge,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  hideDialog();
                },
                child: Text(
                  cancelText,
                  style: Get.textTheme.titleMedium,
                ),
              ),
              FilledButton(
                onPressed: () {
                  hideDialog();
                  result = true;
                },
                child: Text(
                  confirmText,
                  style: Get.textTheme.titleMedium!.copyWith(
                    color: Get.theme.colorScheme.background,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
  ));
  return result;
}

showLoadingDialog() {
  hideDialog();
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: Container(
      width: Get.size.width * 0.3,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.background,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Get.theme.colorScheme.shadow,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(
            "Đang xử lý...",
            style: Get.textTheme.titleLarge,
          ),
        ],
      ),
    ),
  ));
}

void sessionDetailsDialog(String sessionId) {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  RootViewModel rootViewModel = Get.find<RootViewModel>();
  SessionDetails? sessionDetails;
  menuViewModel.getSessionDetail(sessionId).then((value) {
    sessionDetails = value;
    sessionDetails!.initCashInVault = rootViewModel.defaultCashboxMoney;
    sessionDetails!.currentCashInVault =
        rootViewModel.defaultCashboxMoney + sessionDetails!.totalAmount!;
  });

  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: ScopedModel(
      model: menuViewModel,
      child: ScopedModelDescendant<MenuViewModel>(
          builder: (context, build, model) {
        if (model.status == ViewStatus.Loading) {
          return Container(
            width: Get.size.width * 0.8,
            height: Get.size.height * 0.8,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.shadow,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Đang tải...",
                  style: Get.textTheme.titleLarge,
                ),
              ],
            ),
          );
        } else if (sessionDetails == null) {
          return Container(
            width: Get.size.width * 0.8,
            height: Get.size.height * 0.8,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.shadow,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Không tìm thấy thông tin ca",
                  style: Get.textTheme.titleLarge,
                ),
              ],
            ),
          );
        }
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Get.theme.colorScheme.shadow,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sessionDetails?.name ?? "",
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        hideDialog();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Get.theme.colorScheme.onBackground,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Get.theme.colorScheme.onBackground,
              ),
              Text(
                "${formatOnlyTime(sessionDetails?.startDateTime ?? '')} - ${formatOnlyTime(sessionDetails?.endDateTime ?? '')} ${formatOnlyDate(sessionDetails?.endDateTime ?? '')}",
                style: Get.textTheme.titleMedium,
              ),
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Wrap(
                      children: [
                        dashboardCard(
                          title: "Tổng số đơn hàng",
                          value: sessionDetails!.numberOfOrders.toString(),
                        ),
                        dashboardCard(
                          title: "Tổng doanh thu",
                          value: formatPrice(sessionDetails?.totalAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Tổng khuyến mãi",
                          value: formatPrice(
                              sessionDetails?.totalDiscountAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Tổng giảm giá",
                          value:
                              formatPrice(sessionDetails?.totalPromotion ?? 0),
                        ),
                        dashboardCard(
                          title: "Tổng doanh thu sau khuyến mãi",
                          value: formatPrice(sessionDetails?.profitAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Số tiền hiện có trong két",
                          value: formatPrice(
                              sessionDetails?.currentCashInVault ?? 0),
                        ),
                        dashboardCard(
                          title: "Số tiền khởi tạo trong két",
                          value:
                              formatPrice(sessionDetails?.initCashInVault ?? 0),
                        ),
                      ],
                    ),
                  ],
                )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.find<MenuViewModel>()
                          .printCloseSessionInvoice(sessionDetails!);
                    },
                    child: Text(
                      "In biên lai",
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    ),
  ));
}

Widget dashboardCard({required String title, required String value}) {
  return Card(
    child: Container(
      padding: EdgeInsets.all(16),
      height: 160,
      width: 240,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: Get.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            color: Get.theme.colorScheme.onBackground,
          ),
          Expanded(
              child: Center(
            child: Text(
              value,
              style: Get.textTheme.titleLarge,
            ),
          )),
        ],
      ),
    ),
  );
}

void orderInfoDialog(String orderId) {
  hideDialog();
  Get.find<OrderViewModel>().getOrderByStore(orderId);
  Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return Container(
              width: Get.size.width * 0.8,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Đang xử lý...",
                    style: Get.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          } else if (model.currentOrder == null) {
            return Container(
              width: Get.size.width * 0.8,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Không tìm thấy đơn hàng",
                    style: Get.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          return Container(
              width: Get.size.width * 0.6,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Thông tin đơn hàng",
                            style: Get.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            hideDialog();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Get.theme.colorScheme.onBackground,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Get.theme.colorScheme.onBackground,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          'Tên',
                                          style: Get.textTheme.bodyMedium,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          'SL',
                                          style: Get.textTheme.bodyMedium,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'Tổng',
                                            style: Get.textTheme.bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Get.theme.colorScheme.onSurface,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                model.currentOrder!.productList!.length ?? 0,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return productItem(
                                  model.currentOrder!.productList![i]);
                            },
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Mã',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.currentOrder!.invoiceId ?? "",
                                style: Get.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Nhận món',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                showOrderType(model.currentOrder!.orderType!)
                                    .label,
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Khách hàng',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                'Người dùng',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Trạng thái',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                showOrderStatus(
                                    model.currentOrder!.orderStatus ?? ""),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Phuơng thức',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.currentOrder!.payment!.name ?? "",
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Thời gian',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatTime(
                                    model.currentOrder!.checkInDate ?? ""),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Tạm tính',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatPrice(model.currentOrder!.totalAmount!),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Giảm giá',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                " - ${formatPrice(model.currentOrder!.discount!)}",
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '%VAT',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                percentCalculation(model.currentOrder!.vat!),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'VAT',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatPrice(model.currentOrder!.vatAmount ?? 0),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Tổng tiền',
                                style: Get.textTheme.titleMedium,
                              ),
                              Text(
                                formatPrice(model.currentOrder!.finalAmount!),
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        }),
      )));
}

Widget productItem(ProductList item) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
    child: Column(
      children: [
        Row(
          textDirection: TextDirection.ltr,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name!,
                    style: Get.textTheme.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                  Text(
                    formatPrice(item.sellingPrice!),
                    style: Get.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${item.quantity}",
                    style: Get.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  formatPrice(item.totalAmount!),
                  style: Get.textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: item.extras?.length,
          physics: ScrollPhysics(),
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      "+${item.extras![i].name!}",
                      style: Get.textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Text(
                        formatPrice(item.extras![i].sellingPrice!),
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (item.note != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(item.note!,
                  style: Get.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        Divider(
          color: Get.theme.colorScheme.onSurface,
          thickness: 0.5,
        )
      ],
    ),
  );
}

void hideDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
  }
}

void hideSnackbar() {
  if (Get.isSnackbarOpen) {
    Get.back();
  }
}

void hideBottomSheet() {
  if (Get.isBottomSheetOpen ?? false) {
    Get.back();
  }
}

Future<String?> inputDialog(String title, String hint, String? value,
    {bool isNum = false}) async {
  hideDialog();
  String? result;
  await Get.dialog(AlertDialog(
    title: Text(title),
    content: TextField(
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      inputFormatters:
          isNum ? [FilteringTextInputFormatter.digitsOnly] : null, // Only numb
      controller: TextEditingController(text: value),
      decoration: InputDecoration(hintText: hint),
      onChanged: (value) {
        result = value;
      },
    ),
    actions: [
      TextButton(
          onPressed: () {
            Get.back(result: result);
          },
          child: Text('Cập nhật')),
      TextButton(
          onPressed: () {
            Get.back(result: value);
          },
          child: Text('Huỷ')),
    ],
  ));
  return result;
}

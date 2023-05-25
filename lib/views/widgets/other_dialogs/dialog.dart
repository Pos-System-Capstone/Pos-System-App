import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/data/model/response/session_detail_report.dart';
import 'package:pos_apps/data/model/response/session_details.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/report_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/model/response/sessions.dart';
import '../../../enums/view_status.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              content,
              style: Get.textTheme.bodyLarge,
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              content,
              style: Get.textTheme.bodyLarge,
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

void sessionDetailsDialog(Session session) {
  ReportViewModel reportViewModel = ReportViewModel();

  SessionDetailReport? sessionDetailReport;

  reportViewModel
      .getSessionDetailReport(sessionId: session.id ?? '')
      .then((value) {
    sessionDetailReport = value;
  });

  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
    child: ScopedModel(
      model: reportViewModel,
      child: ScopedModelDescendant<ReportViewModel>(
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
        } else if (sessionDetailReport == null) {
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
                  "Không tìm thấy thông tin báo cáo",
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
                      session.name ?? "",
                      style: Get.textTheme.titleLarge,
                    ),
                  ),
                  Text(
                    "${formatOnlyTime(session.startDateTime ?? '')} - ${formatOnlyTime(session.endDateTime ?? '')} ${formatOnlyDate(session.endDateTime ?? '')}",
                    style: Get.textTheme.titleMedium,
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
                    Wrap(
                      children: [
                        dashboardCard(
                          title: "Tổng số đơn hàng",
                          value: sessionDetailReport!.totalOrder.toString(),
                        ),
                        dashboardCard(
                          title: "Doanh thu trước khuyến mãi",
                          value: formatPrice(
                              sessionDetailReport?.totalAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Giảm giá",
                          value: formatPrice(
                              sessionDetailReport?.totalDiscount ?? 0),
                        ),
                        dashboardCard(
                          title: "Doanh thu sau khuyến mãi",
                          value: formatPrice(
                              sessionDetailReport?.finalAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Số đơn tiền mặt",
                          value:
                              sessionDetailReport?.totalCash.toString() ?? "0",
                        ),
                        dashboardCard(
                          title: "Số đơn MOMO",
                          value:
                              sessionDetailReport?.totalMomo.toString() ?? "0",
                        ),
                        dashboardCard(
                          title: "Số đơn chuyển khoản",
                          value: sessionDetailReport?.totalBanking.toString() ??
                              "0",
                        ),
                        dashboardCard(
                          title: "Số đơn Visa",
                          value:
                              sessionDetailReport?.totalVisa.toString() ?? "0",
                        ),
                        dashboardCard(
                          title: "Doanh thu tiền mặt",
                          value:
                              formatPrice(sessionDetailReport?.cashAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Doanh thu MOMO",
                          value:
                              formatPrice(sessionDetailReport?.momoAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Doanh thu chuyển khoản",
                          value: formatPrice(
                              sessionDetailReport?.bankingAmount ?? 0),
                        ),
                        dashboardCard(
                          title: "Doanh thu Visa",
                          value:
                              formatPrice(sessionDetailReport?.visaAmount ?? 0),
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
                      model.printCloseSessionInvoice(
                          session, sessionDetailReport!);
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
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                title,
                style: Get.textTheme.titleMedium,
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
                    formatPrice(item.sellingPrice ?? 0),
                    style: Get.textTheme.bodyMedium,
                  )
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
                child: Column(
                  children: [
                    Text(
                      formatPrice(item.totalAmount!),
                      style: Get.textTheme.bodyLarge,
                    ),
                    item.discount != 0
                        ? Text(
                            "-${formatPrice(item.discount!)}",
                            style: Get.textTheme.bodyMedium,
                          )
                        : SizedBox(),
                  ],
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
              child: Text(item.note ?? '',
                  style: Get.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
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

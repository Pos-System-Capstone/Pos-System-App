import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
                  result = true;
                  hideDialog();
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

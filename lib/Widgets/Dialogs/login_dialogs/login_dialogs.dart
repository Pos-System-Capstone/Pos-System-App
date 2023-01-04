import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/widgets/dialogs/other_dialogs/dialog.dart';

Future<void> showLoginErrorDialog(String errorMessage) async {
  hideDialog();
  await Get.dialog(
    AlertDialog(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
            child: Icon(Icons.warning_amber_rounded, color: Colors.red),
          ),
          SizedBox(
            width: 8,
          ),
          Text('Lỗi đăng nhập'),
        ],
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              "Vui lòng đăng nhập lại !\n$errorMessage",
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Thử lại'),
          onPressed: () {
            hideDialog();
          },
        ),
      ],
    ),
  );
}

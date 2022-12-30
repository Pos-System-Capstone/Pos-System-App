import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/widgets/dialogs/other_dialogs/dialog.dart';

Future<void> showLoginErrorDialog(String errorMessage) async {
  hideDialog();
  await Get.dialog(
    AlertDialog(
      title: const Text('Login Error'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(errorMessage),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String?> scanPointifyWallet() async {
  TextEditingController value = TextEditingController();
  String? result;
  await Get.dialog(AlertDialog(
    title: Text("Quét thẻ thành viên"),
    content: SizedBox(
      width: Get.width * 0.5,
      height: 160,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              controller: value,
              decoration:
                  InputDecoration(hintText: " Vui lòng quét mã để thanh toán"),
              onChanged: (value) {
                result = value;
              },
            ),
          ),
        ],
      ),
    ),
    actions: [
      FilledButton.tonal(
          onPressed: () {
            Get.back(result: result);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Thanh toán', style: Get.textTheme.titleMedium),
          )),
      TextButton(
          onPressed: () {
            Get.back(result: value);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Huỷ', style: Get.textTheme.titleMedium),
          )),
    ],
  ));
  return result;
}

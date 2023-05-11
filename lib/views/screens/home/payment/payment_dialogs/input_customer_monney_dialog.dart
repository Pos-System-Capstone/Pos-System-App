import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pos_apps/util/format.dart';

import '../../../../widgets/other_dialogs/dialog.dart';

Future<num> inputMonneyDialog({bool isNum = true}) async {
  List<num> list = [50000, 100000, 200000, 500000];
  TextEditingController value = TextEditingController();
  num result = 0;
  await Get.dialog(AlertDialog(
    title: Text("Nhập số tiền khách đưa"),
    content: SizedBox(
      width: Get.width * 0.6,
      height: 300,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ], // Only numb
              controller: value,
              decoration:
                  InputDecoration(hintText: " Vui lòng nhập số tiền khách đưa"),
              onChanged: (value) {
                result = value.isEmpty ? 0 : num.parse(value);
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (int i = 0; i < list.length; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () {
                            result = list[i];
                            Get.back(result: result);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(formatPrice(list[i]),
                                style: Get.textTheme.titleMedium),
                          ),
                        ),
                      ),
                  ]),
            ),
          )
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
            child: Text('Cập nhật', style: Get.textTheme.titleMedium),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/views/screens/home/cart/dialog/choose_deli_type_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/other_dialogs/dialog.dart';

void chooseTableDialog() {
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    child: ScopedModel(
      model: Get.find<CartViewModel>(),
      child: ScopedModelDescendant<CartViewModel>(
        builder: (context, child, model) {
          int numberOfTable = Get.find<RootViewModel>().numberOfTable;
          return SizedBox(
            width: Get.width * 0.9,
            height: Get.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                      alignment: Alignment.center,
                      child: Text("Chọn số thứ tự",
                          style: Get.textTheme.titleLarge)),
                ),
                Divider(
                  height: 1,
                  color: Get.theme.colorScheme.onSurface,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (int i = 1; i <= numberOfTable; i++)
                          InkWell(
                            onTap: () {
                              model.chooseTable(i);
                              chooseDeliTypeDialog();
                            },
                            child: Card(
                              color: model.cart.customerNumber == i
                                  ? Get.theme.colorScheme.primaryContainer
                                  : Get.theme.colorScheme.background,
                              child: SizedBox(
                                width: 100,
                                height: 110,
                                child: Center(
                                  child: Text(
                                    i < 10 ? '0$i' : '$i',
                                    style: Get.textTheme.displaySmall,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  ));
}

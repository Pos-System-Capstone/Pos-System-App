import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../enums/order_enum.dart';
import '../../view_model/order_view_model.dart';
import '../../view_model/root_view_model.dart';

void chooseTableDialog() {
  hideDialog();
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    child: ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          int numberOfTable = Get.find<RootViewModel>().numberOfTable;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.shopping_cart, size: 32),
                    ),
                    Expanded(
                        child: Center(
                            child: Text("Chọn số bàn",
                                style: Get.textTheme.titleLarge))),
                    IconButton(
                        iconSize: 40,
                        onPressed: () => Get.back(),
                        icon: Icon(Icons.close))
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: [
                          for (int i = 1; i <= numberOfTable; i++)
                            InkWell(
                              onTap: () {
                                model.chooseTable(i);
                              },
                              child: Card(
                                color: model.selectedTable == i
                                    ? Get.theme.colorScheme.primaryContainer
                                    : Get.theme.colorScheme.background,
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
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
                )
              ],
            ),
          );
        },
      ),
    ),
  ));
}

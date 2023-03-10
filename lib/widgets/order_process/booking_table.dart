import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/view_model/order_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

class BookingTableScreen extends StatelessWidget {
  const BookingTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          int numberOfTable = Get.find<RootViewModel>().numberOfTable;
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24),
                      onPressed: () {
                        model.changeState(OrderStateEnum.CHOOSE_ORDER_TYPE);
                      },
                    ),
                    Text("Chọn bàn", style: Get.textTheme.titleLarge),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Wrap(
                        // mainAxisSpacing: isPortrait ? 2 : 8,
                        // crossAxisSpacing: isPortrait ? 2 : 8,
                        // crossAxisCount: isPortrait ? 4 : 8,
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
                                child: Container(
                                  width: 80,
                                  height: 80,
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
    );
  }
}

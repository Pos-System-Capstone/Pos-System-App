import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/order_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

class BookingTableScreen extends StatelessWidget {
  const BookingTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          int numberOfTable = model.numberOfTable;
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            child: GridView.count(
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              crossAxisCount: 8,
              children: [
                for (int i = 1; i <= numberOfTable; i++)
                  InkWell(
                    onTap: () {
                      model.chooseTable(i);
                    },
                    child: Card(
                      color: model.selectedTable == i
                          ? Get.theme.colorScheme.primary
                          : Get.theme.colorScheme.background,
                      child: Center(
                        child: Text(
                          i < 10 ? '0$i' : '$i',
                          style: Get.textTheme.displaySmall,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

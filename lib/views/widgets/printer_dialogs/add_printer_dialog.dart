import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

void showPrinterConfigDialog(PrinterTypeEnum type) {
  Get.bottomSheet(BottomSheet(
    onClosing: () {
      Get.back();
    },
    builder: (BuildContext context) {
      return ScopedModel(
        model: Get.find<PrinterViewModel>(),
        child: ScopedModelDescendant<PrinterViewModel>(
            builder: (context, child, model) {
          return SizedBox(
            height: Get.size.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    type == PrinterTypeEnum.bill
                        ? 'Thiết lập in hóa đơn'
                        : 'Thiết lập Máy in tem',
                    style: Get.textTheme.titleLarge,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () => model.scanPrinter(),
                        child: model.status == ViewStatus.Loading
                            ? Text('Dang tìm kiếm...')
                            : Text('Tìm kiếm')),
                    SizedBox(width: 8),
                    Text(
                      'Tìm thấy: ${model.listDevice?.length} thiết bị',
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        model.listDevice != null ? model.listDevice!.length : 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          Container(
                            height: 60,
                            padding: EdgeInsets.only(left: 8, right: 8),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.print),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    model.listDevice![index].name,
                                  ),
                                ),
                                SizedBox(width: 8),
                                type == PrinterTypeEnum.bill
                                    ? model.isBillPrinterConnected(
                                            model.listDevice![index])
                                        ? TextButton(
                                            onPressed: () =>
                                                model.removeBillPrinter(),
                                            child: Text("Xoá"))
                                        : FilledButton(
                                            onPressed: () =>
                                                model.selectBillPrinter(
                                                  model.listDevice![index],
                                                ),
                                            child: Text("Kết nối"))
                                    : model.isStampPrinterConnected(
                                            model.listDevice![index])
                                        ? TextButton(
                                            onPressed: () =>
                                                model.removeStampPrinter(),
                                            child: Text("Xóa"))
                                        : FilledButton(
                                            onPressed: () =>
                                                model.selectProductPrinter(
                                                  model.listDevice![index],
                                                ),
                                            child: Text("Kết nối")),
                                SizedBox(width: 8),
                                OutlinedButton(
                                    onPressed: () => model
                                        .testPrinter(model.listDevice![index]),
                                    child: Text("In thử"))
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }),
      );
    },
  ));
}

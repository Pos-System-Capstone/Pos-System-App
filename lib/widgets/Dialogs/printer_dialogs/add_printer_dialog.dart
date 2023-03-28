import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

void showInputIpDialog() {
  Get.bottomSheet(BottomSheet(
    onClosing: () {
      Get.back();
    },
    builder: (BuildContext context) {
      return ScopedModel(
        model: Get.find<PrinterViewModel>(),
        child: ScopedModelDescendant<PrinterViewModel>(
            builder: (context, child, model) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Thiết lập Máy in',
                  style: Get.textTheme.titleLarge,
                ),
              ),
              FilledButton(
                  onPressed: () => model.scanPrinter(),
                  child: model.status == ViewStatus.Loading
                      ? Text('Dang tìm kiếm...')
                      : Text('Tìm kiếm')),
              SizedBox(height: 15),
              Text(
                'Tìm thấy: ${model.listDevice?.length} thiết bị',
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
                              model.isPrinterConnected(model.listDevice![index])
                                  ? TextButton(
                                      onPressed: () => null, child: Text("Xoá"))
                                  : FilledButton(
                                      onPressed: () => model.selectBillPrinter(
                                            model.listDevice![index],
                                          ),
                                      child: Text("Ket noi")),
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
          );
        }),
      );
    },
  ));
}

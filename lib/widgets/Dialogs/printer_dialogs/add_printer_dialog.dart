import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
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
        model: Get.find<NetworkPrinterViewModel>(),
        child: ScopedModelDescendant<NetworkPrinterViewModel>(
            builder: (context, child, model) {
          TextEditingController portController =
              TextEditingController(text: '9100');
          TextEditingController ipController =
              TextEditingController(text: '192.168.31.1');
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Thiết lập Máy in',
                  style: Get.textTheme.titleLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "IP:",
                        style: Get.textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: ipController,
                        decoration: InputDecoration(
                          labelText: 'Ip',
                          hintText: '192.168.31.1',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Port:",
                        style: Get.textTheme.titleMedium,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: portController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Port',
                          hintText: '9100',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text('Ip: ${Get.find<NetworkPrinterViewModel>().selectedIp}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 15),
              FilledButton(
                  onPressed: () => model.printerScan(PrinterType.network),
                  child: model.status == ViewStatus.Loading
                      ? Text('Dang tìm kiếm...')
                      : Text('Tìm kiếm')),
              SizedBox(height: 15),
              Text(
                'Tìm thấy: ${model.devices.length} thiết bị',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: model.printerDevices.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.print),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  model.printerDevices[index].name,
                                ),
                              ),
                              SizedBox(width: 8),
                              false
                                  ? TextButton(
                                      onPressed: () => model.deletePrinter(),
                                      child: Text("Xoá"))
                                  : FilledButton(
                                      onPressed: () => model.selectDevice(
                                            model.printerDevices[index],
                                            PrinterType.network,
                                          ),
                                      child: Text("Ket noi")),
                              SizedBox(width: 8),
                              OutlinedButton(
                                  onPressed: () => model
                                      .printReceiveTest(PrinterType.network),
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

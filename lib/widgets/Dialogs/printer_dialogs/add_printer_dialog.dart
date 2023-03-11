import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

void showInputIpDialog() {
  Get.bottomSheet(BottomSheet(
    builder: (BuildContext context) {
      return ScopedModel(
        model: Get.find<NetworkPrinterViewModel>(),
        child: ScopedModelDescendant(
            builder: (context, child, NetworkPrinterViewModel model) {
          TextEditingController portController =
              TextEditingController(text: '9100');
          TextEditingController ipController =
              TextEditingController(text: '192.168.31.1');
          return Column(
            children: [
              Text(
                'Máy in',
                style: Get.textTheme.titleLarge,
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
                  onPressed: () =>
                      model.discover(ipController.text, portController.text),
                  child: Text('Tìm kiếm')),
              SizedBox(height: 15),
              Get.find<NetworkPrinterViewModel>().found >= 0
                  ? Text('Tìm thấy: ${model.found} thiết bị',
                      style: TextStyle(fontSize: 16))
                  : Container(),
              Expanded(
                child: ListView.builder(
                  itemCount: model.devices.length,
                  itemBuilder: (BuildContext context, int index) {
                    String currentDevice = model.devices[index];
                    String currentPort = model.selectedPort.toString();
                    bool isSave = model.isDeviceSaved(currentDevice);

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
                                  '$currentDevice:$currentPort',
                                ),
                              ),
                              SizedBox(width: 8),
                              isSave
                                  ? FilledButton(
                                      onPressed: () => model
                                          .savePrinterDevice(currentDevice),
                                      child: Text("Lưu"))
                                  : TextButton(
                                      onPressed: () => model.deletePrinter(),
                                      child: Text("Xoá")),
                              SizedBox(width: 8),
                              OutlinedButton(
                                  onPressed: () =>
                                      model.testPrint(currentDevice),
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
    onClosing: () {},
  ));
}

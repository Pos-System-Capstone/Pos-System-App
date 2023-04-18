import 'dart:ffi';

import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:pos_apps/Widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/printer_view_model.dart';
import 'package:pos_apps/view_model/theme_view_model.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../Widgets/Dialogs/printer_dialogs/add_printer_dialog.dart';
import '../enums/order_enum.dart';
import '../theme/theme_color.dart';
import '../util/share_pref.dart';
import '../view_model/login_view_model.dart';
import '../view_model/menu_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  RootViewModel rootViewModel = Get.find<RootViewModel>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: rootViewModel,
        child: ScopedModelDescendant<RootViewModel>(
            builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "Cài đặt",
                        style: Get.textTheme.titleLarge,
                      )),
                  themeSetting(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Số lượng bàn', style: Get.textTheme.titleMedium),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: () {
                                  model.decreaseNumberOfTabele();
                                },
                                icon: Icon(
                                  Icons.remove,
                                  size: 32,
                                )),
                            Text("${model.numberOfTable}",
                                style: Get.textTheme.titleLarge),
                            IconButton(
                                onPressed: () {
                                  model.increaseNumberOfTabele();
                                },
                                icon: Icon(
                                  Icons.add,
                                  size: 32,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Expanded(
                  //           child: Text('Tiền mặt trong quầy',
                  //               style: Get.textTheme.titleMedium)),
                  //       OutlinedButton.icon(
                  //           onPressed: () async {
                  //             String? money = await inputDialog(
                  //                 "Nhập số tiền",
                  //                 "Vui long nhập số tiền",
                  //                 model.defaultCashboxMoney.toString(),
                  //                 isNum: true);
                  //             if (money != null) {
                  //               model.setCashboxMoney(int.parse(money));
                  //             }
                  //           },
                  //           icon: Icon(Icons.change_circle_outlined),
                  //           label:
                  //               Text(formatPrice(model.defaultCashboxMoney))),
                  //     ],
                  //   ),
                  // ),
                  // Divider(
                  //   thickness: 1,
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Máy in hoá đơn',
                                style: Get.textTheme.titleMedium),
                            Get.find<PrinterViewModel>().selectedBillPrinter !=
                                    null
                                ? Text(
                                    Get.find<PrinterViewModel>()
                                        .selectedBillPrinter!
                                        .url,
                                  )
                                : Text("Chưa kết nối thiết bị"),
                          ],
                        ),
                        OutlinedButton(
                            onPressed: () =>
                                showPrinterConfigDialog(PrinterTypeEnum.bill),
                            child: Text("Tuỳ chỉnh"))
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Máy in tem',
                                style: Get.textTheme.titleMedium),
                            Get.find<PrinterViewModel>()
                                        .selectedProductPrinter !=
                                    null
                                ? Text(
                                    Get.find<PrinterViewModel>()
                                        .selectedProductPrinter!
                                        .url,
                                  )
                                : Text(" Chưa kết nối thiết bị"),
                          ],
                        ),
                        OutlinedButton(
                            onPressed: () =>
                                showPrinterConfigDialog(PrinterTypeEnum.stamp),
                            child: Text("Tuỳ chỉnh"))
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text('Cập nhật dữ liệu',
                                style: Get.textTheme.titleMedium)),
                        IconButton(
                          alignment: Alignment.bottomCenter,
                          tooltip: "Cập nhật",
                          onPressed: () =>
                              Get.find<MenuViewModel>().getMenuOfStore(),
                          icon: Icon(
                            Icons.browser_updated,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text('Hiển thị Thực đơn',
                                style: Get.textTheme.titleMedium)),
                        IconButton(
                          alignment: Alignment.bottomCenter,
                          tooltip: "Mở",
                          onPressed: () => Get.find<OrderViewModel>()
                              .launchInBrowser(
                                  'https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fmenu-deer.jpg?alt=media&token=cfba9091-79c7-4a19-9f62-fd948768f64e'),
                          icon: Icon(
                            Icons.menu_book_outlined,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text('Đăng xuất',
                                style: Get.textTheme.titleMedium)),
                        IconButton(
                          alignment: Alignment.bottomCenter,
                          tooltip: "Đăng xuất",
                          onPressed: () => {
                            showConfirmDialog(
                              title: "Đăng xuất",
                              content: "Bạn có muốn đăng xuất không?",
                            ).then((value) => {
                                  if (value)
                                    Get.find<LoginViewModel>().logout(),
                                })
                          },
                          icon: Icon(
                            Icons.logout,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                ]),
          ));
        }));
  }

  Widget themeSetting() {
    return ScopedModel(
        model: ThemeViewModel(),
        child: ScopedModelDescendant<ThemeViewModel>(
            builder: (context, child, model) {
          return Column(
            children: [
              SwitchListTile(
                title: Text('Chế độ tối'),
                value: context.isDarkMode,
                onChanged: (value) {
                  model.toggleTheme();
                },
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Màu nền', style: Get.textTheme.titleMedium),
                    PopupMenuButton(
                      tooltip: "Đổi màu sắc",
                      icon: Icon(
                        Icons.colorize,
                        color: Get.theme.colorScheme.primary,
                        size: 32,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (context) {
                        return List.generate(colorOptions.length, (index) {
                          Future<int?> idx = getThemeColor();
                          return PopupMenuItem(
                              value: index,
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Icon(
                                      idx == index
                                          ? Icons.color_lens
                                          : Icons.color_lens_outlined,
                                      color: colorOptions[index],
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: Text(colorText[index]))
                                ],
                              ));
                        });
                      },
                      onSelected: (index) {
                        model.handleColorSelect(index);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          );
        }));
  }
}

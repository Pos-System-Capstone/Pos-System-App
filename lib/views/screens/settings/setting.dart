import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/screens/settings/promotion_setting_bottom_sheet.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../theme/theme_color.dart';
import '../../../../util/share_pref.dart';
import '../../widgets/other_dialogs/dialog.dart';
import '../../widgets/printer_dialogs/add_printer_dialog.dart';
import 'product_atrribute_bottom_sheet.dart';

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text('Tiền mặt trong quầy',
                                style: Get.textTheme.titleMedium)),
                        OutlinedButton(
                            onPressed: () async {
                              String? money = await inputDialog(
                                  "Nhập số tiền",
                                  "Vui long nhập số tiền",
                                  model.defaultCashboxMoney.toString(),
                                  isNum: true);
                              if (money != null) {
                                model.setCashboxMoney(int.parse(money));
                              }
                            },
                            child:
                                Text(formatPrice(model.defaultCashboxMoney))),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  billPrinterSetting(),
                  Divider(
                    thickness: 1,
                  ),
                  stampPrinterSetting(),
                  Divider(
                    thickness: 1,
                  ),
                  updateMenu(),
                  Divider(
                    thickness: 1,
                  ),
                  productAttributesSetting(),
                  Divider(
                    thickness: 1,
                  ),
                  promotionSetting(),
                  Divider(
                    thickness: 1,
                  ),
                  displayMenu(),
                  Divider(
                    thickness: 1,
                  ),
                  logoutSetting(),
                  Divider(
                    thickness: 1,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  //   child: InkWell(
                  //     onTap: () =>
                  //         Get.find<PrinterViewModel>().testPrinterMobile(),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //             child: Text('Test print mobile',
                  //                 style: Get.textTheme.titleMedium)),
                  //         IconButton(
                  //           alignment: Alignment.bottomCenter,
                  //           tooltip: "Đăng xuất",
                  //           onPressed: () => {
                  //             showConfirmDialog(
                  //               title: "Đăng xuất",
                  //               content: "Bạn có muốn đăng xuất không?",
                  //             ).then((value) => {
                  //                   if (value)
                  //                     Get.find<PrinterViewModel>()
                  //                         .testPrinterMobile(),
                  //                 })
                  //           },
                  //           icon: Icon(
                  //             Icons.logout,
                  //             size: 32,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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

  Widget billPrinterSetting() {
    return InkWell(
      onTap: () => showPrinterConfigDialog(PrinterTypeEnum.bill),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Máy in hoá đơn', style: Get.textTheme.titleMedium),
                  Get.find<PrinterViewModel>().selectedBillPrinter != null
                      ? Text(
                          Get.find<PrinterViewModel>().selectedBillPrinter!.url,
                        )
                      : Text("Chưa kết nối thiết bị"),
                ],
              ),
            ),
            Icon(
              Icons.print,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget stampPrinterSetting() {
    return InkWell(
      onTap: () => showPrinterConfigDialog(PrinterTypeEnum.stamp),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Máy in tem', style: Get.textTheme.titleMedium),
                  Get.find<PrinterViewModel>().selectedProductPrinter != null
                      ? Text(
                          Get.find<PrinterViewModel>()
                              .selectedProductPrinter!
                              .url,
                        )
                      : Text(" Chưa kết nối thiết bị"),
                ],
              ),
            ),
            Icon(
              Icons.print_outlined,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget updateMenu() {
    return InkWell(
      onTap: () => Get.find<MenuViewModel>().getMenuOfStore(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cập nhật menu', style: Get.textTheme.titleMedium),
                ],
              ),
            ),
            Icon(
              Icons.update,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget productAttributesSetting() {
    return InkWell(
      onTap: () => showProductAttributesBottomSheet(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Thuộc tính sản phẩm', style: Get.textTheme.titleMedium),
                ],
              ),
            ),
            Icon(
              Icons.edit_attributes,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget promotionSetting() {
    return InkWell(
      onTap: () => showPromotionConfigBottomSheet(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tuỳ chỉnh khuyến mãi',
                      style: Get.textTheme.titleMedium),
                ],
              ),
            ),
            Icon(
              Icons.card_giftcard,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutSetting() {
    return InkWell(
      onTap: () => {
        showConfirmDialog(
          title: "Đăng xuất",
          content: "Bạn có muốn đăng xuất không?",
        ).then((value) => {
              if (value) Get.find<LoginViewModel>().logout(),
            })
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Đăng xuất', style: Get.textTheme.titleMedium),
                ],
              ),
            ),
            Icon(
              Icons.logout,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget displayMenu() {
    String? brandLogo = Get.find<MenuViewModel>().storeDetails.brandPicUrl;
    return InkWell(
      onTap: () => Get.find<OrderViewModel>().launchInBrowser(brandLogo ?? ""),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hiển thị logo', style: Get.textTheme.titleMedium),
                ],
              ),
            ),
            Icon(
              Icons.open_in_browser_rounded,
              size: 32,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}

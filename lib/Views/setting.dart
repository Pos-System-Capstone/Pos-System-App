import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/theme_color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color colorSelect = colorOptions[0];
  bool isNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // colorSelect = prefs.getString('color');
      isNotificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  saveSettings(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: Get.find<RootViewModel>(),
        child: ScopedModelDescendant<RootViewModel>(
            builder: (context, child, model) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Settings'),
                // actions: [
                //   IconButton(
                //     icon: !Get.isDarkMode
                //         ? const Icon(Icons.wb_sunny_outlined)
                //         : const Icon(Icons.wb_sunny),
                //     onPressed: null,
                //     tooltip: "Toggle brightness",
                //   ),
                //   PopupMenuButton(
                //     icon: const Icon(Icons.more_vert),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10)),
                //     itemBuilder: (context) {
                //       return List.generate(colorOptions.length, (index) {
                //         return PopupMenuItem(
                //             value: index,
                //             child: Wrap(
                //               children: [
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 10),
                //                   child: Icon(
                //                     Icons.color_lens,
                //                     // index == colorSelected
                //                     //     ? Icons.color_lens
                //                     //     : Icons.color_lens_outlined,
                //                     color: colorOptions[index],
                //                   ),
                //                 ),
                //                 Padding(
                //                     padding: const EdgeInsets.only(left: 20),
                //                     child: Text(colorText[index]))
                //               ],
                //             ));
                //       });
                //     },
                //     onSelected: null,
                //   ),
                // ],
              ),
              body: Container(
                child: Column(children: [
                  SwitchListTile(
                    title: Text('Chế độ tối'),
                    value: Get.isDarkMode,
                    onChanged: (value) {
                      model.handleChangeTheme();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
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
                  )
                ]),
              ));
        }));
  }
}

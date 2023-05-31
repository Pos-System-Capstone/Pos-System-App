import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../util/format.dart';
import '../../widgets/other_dialogs/dialog.dart';
import 'dialog/report_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  TextEditingController dateInputController = TextEditingController();
  @override
  initState() {
    super.initState();
    menuViewModel.getListSession(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: menuViewModel,
        child: ScopedModelDescendant<MenuViewModel>(
            builder: (context, build, model) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Ca làm việc", style: Get.textTheme.titleLarge),
                    SizedBox(
                      width: 8.0,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: Get.context!,
                            helpText: "Chọn ngày",
                            confirmText: "Xem danh sách ca",
                            cancelText: "Hủy",
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2025),
                            initialDate: DateTime.now());

                        if (pickedDate != null) {
                          model.getListSession(pickedDate);
                        }
                      },
                      child: Text("Chọn ngày"),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        for (var item in model.sessions!)
                          Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () => sessionDetailsDialog(item),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                width: 240,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.name ?? '',
                                      style: Get.textTheme.titleMedium,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "${formatOnlyTime(item.startDateTime ?? '')} - ${formatOnlyTime(item.endDateTime ?? '')}",
                                      style: Get.textTheme.titleMedium,
                                    ),
                                    Text(
                                      formatOnlyDate(item.startDateTime ?? ''),
                                      style: Get.textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Text("Báo cáo chi tiết ngày", style: Get.textTheme.titleLarge),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: Get.context!,
                            helpText: "Chọn ngày",
                            confirmText: "Xem báo cáo",
                            cancelText: "Hủy",
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2025),
                            initialDate: DateTime.now());

                        if (pickedDate != null) {
                          reportDetailsDialog(pickedDate, pickedDate);
                        }
                      },
                      child: Text("Chọn ngày"),
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

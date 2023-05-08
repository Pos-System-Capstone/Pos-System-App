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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: menuViewModel,
        child: ScopedModelDescendant<MenuViewModel>(
            builder: (context, build, model) {
          return Container(
            width: Get.width,
            height: Get.height,
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                              radius: 48,
                              backgroundImage: NetworkImage(
                                model.storeDetails.brandPicUrl ??
                                    "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fcash-register.png?alt=media&token=fb8b55e5-ce62-40a7-9099-b32c93e94532",
                              )),
                          SizedBox(width: 12.0),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${model.storeDetails.name}(${model.storeDetails.code})",
                                  style: Get.textTheme.titleMedium,
                                ),
                                Text(
                                  model.storeDetails.address ?? "Store Name",
                                  style: Get.textTheme.titleSmall,
                                ),
                                Text(
                                  model.storeDetails.phone ?? "Store Name",
                                  style: Get.textTheme.titleSmall,
                                ),
                                Text(
                                  model.storeDetails.email ?? "Store Name",
                                  style: Get.textTheme.titleSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text("Ca làm việc", style: Get.textTheme.titleLarge),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Row(
                        children: [
                          for (var item in model.sessions!)
                            Card(
                              elevation: 2,
                              child: InkWell(
                                onTap: () =>
                                    sessionDetailsDialog(item.id ?? ''),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: 240,
                                  height: 160,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        item.name ?? '',
                                        style: Get.textTheme.titleLarge,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "${formatOnlyTime(item.startDateTime ?? '')} - ${formatOnlyTime(item.endDateTime ?? '')}",
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
                ),
                Text("Báo cáo kết ngày", style: Get.textTheme.titleLarge),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: OutlinedButton(
                      onPressed: () async {
                        DateTimeRange? pickedDateRange =
                            await showDateRangePicker(
                                context: Get.context!,
                                helpText: "Chọn ngày báo cáo",
                                confirmText: "Xem báo cáo",
                                saveText: "Xem báo cáo",
                                cancelText: "Hủy",
                                initialDateRange: DateTimeRange(
                                    start: DateTime.now(), end: DateTime.now()),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2025));

                        if (pickedDateRange != null) {
                          reportDetailsDialog(
                              pickedDateRange.start, pickedDateRange.end);
                        }
                      },
                      child: Text("Xem báo cáo"),
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

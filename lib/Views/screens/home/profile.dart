import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../util/format.dart';
import '../../../widgets/Dialogs/other_dialogs/dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MenuViewModel menuViewModel = Get.find<MenuViewModel>();
  @override
  initState() {
    menuViewModel.getStore();
    menuViewModel.getListSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: menuViewModel,
        child: ScopedModelDescendant<MenuViewModel>(
            builder: (context, build, model) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
              Text("Ca làm việc", style: Get.textTheme.titleLarge),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: [
                        for (var item in model.sessions!)
                          Card(
                            elevation: 2,
                            child: InkWell(
                              onTap: () => sessionDetailsDialog(item),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                width: 180,
                                height: 120,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.name ?? '',
                                      style: Get.textTheme.titleMedium,
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
            ],
          );
        }),
      ),
    );
  }
}

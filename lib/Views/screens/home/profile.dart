import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: Get.find<MenuViewModel>(),
        child: ScopedModelDescendant<MenuViewModel>(
            builder: (context, build, model) {
          return Stack(
            children: <Widget>[
              // Cover image

              // Profile image and name
              Positioned(
                top: 20.0,
                left: 20.0,
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 80.0,
                        backgroundImage: NetworkImage(
                          model.storeDetails.brandPicUrl ??
                              "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fcash-register.png?alt=media&token=fb8b55e5-ce62-40a7-9099-b32c93e94532",
                        )),
                    SizedBox(width: 10.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "${model.storeDetails.name}(${model.storeDetails.code})",
                            style: Get.textTheme.titleLarge),
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
                  ],
                ),
              ),
              // Other widgets
            ],
          );
        }),
      ),
    );
  }
}

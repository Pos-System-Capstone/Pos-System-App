import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

class PromotionInfoScreen extends StatefulWidget {
  const PromotionInfoScreen({super.key});

  @override
  State<PromotionInfoScreen> createState() => _PromotionInfoScreenState();
}

class _PromotionInfoScreenState extends State<PromotionInfoScreen> {
  TextEditingController _nameController = TextEditingController();
  RootViewModel _rootViewModel = Get.find<RootViewModel>();
  List<String>? promotions = [];
  @override
  void initState() {
    super.initState();
    promotions = _rootViewModel.promotions;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ScopedModel(
        model: _rootViewModel,
        child: Container(
          color: Get.theme.colorScheme.background,
          width: Get.size.width,
          height: Get.size.height,
          child: ScopedModelDescendant<RootViewModel>(
              builder: (context, build, model) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Center(
                            child: Text(
                      "Tuỳ chỉnh khuyến mãi",
                      style: Get.textTheme.titleLarge,
                    ))),
                    IconButton(
                        iconSize: 32,
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.close)),
                  ],
                ),
                Divider(
                  color: Get.theme.colorScheme.onBackground,
                ),
                Card(
                  child: ListTile(
                    title: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Nhập tên khuyến mãi"),
                    ),
                    trailing: IconButton(
                        iconSize: 48,
                        onPressed: () {
                          if (_nameController.text.isNotEmpty) {
                            model.setPromotion(_nameController.text);
                            _nameController.clear();
                          }
                        },
                        icon: Icon(Icons.add)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListView.builder(
                    itemCount: model.promotions.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(model.promotions[index]),
                        trailing: IconButton(
                            iconSize: 32,
                            onPressed: () {
                              model.removePromotion(model.promotions[index]);
                            },
                            icon: Icon(Icons.delete_outline_outlined)),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

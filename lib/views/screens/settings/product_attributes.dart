
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/product_attribute.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductAttributeScreen extends StatefulWidget {
  const ProductAttributeScreen({super.key});

  @override
  State<ProductAttributeScreen> createState() => _ProductAttributeScreenState();
}

class _ProductAttributeScreenState extends State<ProductAttributeScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _valueController = TextEditingController();
  RootViewModel _rootViewModel = Get.find<RootViewModel>();
  List<Attribute>? productAttributes = [];
  @override
  void initState() {
    super.initState();
    productAttributes = _rootViewModel.listAttribute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScopedModel(
      model: _rootViewModel,
      child: SizedBox(
        width: Get.size.width,
        height: Get.size.height * 0.9,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Center(
                        child: Text(
                  "Tuỳ chỉnh thuộc tính",
                  style: Get.textTheme.titleMedium,
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
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thêm tuỳ chỉnh : "),
                  ScopedModelDescendant<RootViewModel>(
                      builder: (context, build, model) {
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Expanded(
                                child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nhập tên thuộc tính"),
                              onChanged: (value) {
                                model.setCurrentAttributeName(value);
                              },
                            )),
                          ],
                        ),
                        subtitle: Wrap(children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Chip(
                                deleteButtonTooltipMessage: "Thêm",
                                label: SizedBox(
                                  width: 120,
                                  height: 32,
                                  child: TextField(
                                    controller: _valueController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Tuỳ chọn"),
                                  ),
                                ),
                                deleteIcon: Icon(Icons.add),
                                onDeleted: () {
                                  if (_valueController.text.isNotEmpty) {
                                    model.setCurrentAttributeOption(
                                        _valueController.text);
                                    _valueController.clear();
                                  }
                                }),
                          ),
                          for (var i in model.addAttributes.options)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Chip(
                                  deleteButtonTooltipMessage: "Xóa",
                                  label: Text(i),
                                  deleteIcon: Icon(Icons.close),
                                  onDeleted: () {
                                    model.removeCurrentAttributeOption(i);
                                  }),
                            ),
                        ]),
                        trailing: IconButton(
                            iconSize: 48,
                            onPressed: () {
                              if (_nameController.text.isNotEmpty) {
                                model.addAttribute();
                                _nameController.clear();
                                _valueController.clear();
                              }
                            },
                            icon: Icon(Icons.add)),
                      ),
                    );
                  }),
                  Expanded(
                    child: ScopedModelDescendant<RootViewModel>(
                        builder: (context, build, model) {
                      return ListView.builder(
                        itemCount: model.listAttribute.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(model.listAttribute[index].name),
                            subtitle: Wrap(children: [
                              for (var i in model.listAttribute[index].options)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Chip(
                                      deleteButtonTooltipMessage: "Xóa",
                                      label: Text(i),
                                      deleteIcon: Icon(Icons.close),
                                      onDeleted: () {
                                        model.deleteAttributeOptions(
                                            model.listAttribute[index], i);
                                      }),
                                ),
                            ]),
                            trailing: IconButton(
                                iconSize: 32,
                                onPressed: () {
                                  model.deleteAttribute(
                                      model.listAttribute[index]);
                                },
                                icon: Icon(Icons.delete_outline_outlined)),
                          ),
                        ),
                      );
                    }),
                  )
                ],
              ),
            )),
          ],
        ),
      ),
    ));
  }
}

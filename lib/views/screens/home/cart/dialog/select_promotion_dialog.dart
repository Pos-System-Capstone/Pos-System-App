import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../../data/model/response/promotion.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/other_dialogs/dialog.dart';

void selectPromotionDialog() {
  Get.dialog(Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    child: ScopedModel(
      model: Get.find<CartViewModel>(),
      child: ScopedModelDescendant<CartViewModel>(
        builder: (context, child, model) {
          List<Promotion>? promotions = Get.find<MenuViewModel>().promotions;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.wallet_giftcard_sharp, size: 32),
                  ),
                  Expanded(
                      child: Center(
                          child: Text("Chọn khuyến mãi",
                              style: Get.textTheme.titleLarge))),
                  IconButton(
                      iconSize: 40,
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close))
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    children: [
                      for (Promotion item in promotions!)
                        InkWell(
                          onTap: () {
                            (model.selectedPromotion != null &&
                                    model.selectedPromotion?.id == item.id)
                                ? model.removePromotion()
                                : Get.find<CartViewModel>()
                                    .checkPromotion(item);
                          },
                          child: Card(
                            color: (model.selectedPromotion != null &&
                                    model.selectedPromotion?.id == item.id)
                                ? Get.theme.colorScheme.primaryContainer
                                : Get.theme.colorScheme.background,
                            child: SizedBox(
                              width: 200,
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          item.name ?? '',
                                          style: Get.textTheme.titleMedium,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(item.description ?? ''),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    ),
  ));
}

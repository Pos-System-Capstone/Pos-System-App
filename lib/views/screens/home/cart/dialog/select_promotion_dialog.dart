import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../../data/model/response/promotion.dart';
import '../../../../../view_model/index.dart';
import '../../../../widgets/other_dialogs/dialog.dart';

void selectPromotionDialog() {
  Get.dialog(
    PormotionDialog(),
  );
}

class PormotionDialog extends StatefulWidget {
  const PormotionDialog({super.key});

  @override
  State<PormotionDialog> createState() => _PormotionDialogState();
}

class _PormotionDialogState extends State<PormotionDialog> {
  CartViewModel cartViewModel = Get.find<CartViewModel>();
  @override
  void initState() {
    cartViewModel.getListPromotion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      child: ScopedModel(
        model: cartViewModel,
        child: ScopedModelDescendant<CartViewModel>(
          builder: (context, child, model) {
            if (model.status == ViewStatus.Loading) {
              return Center(child: CircularProgressIndicator());
            }
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
                        for (Promotion item in model.promotions!)
                          InkWell(
                            onTap: () {
                              if (item.isAvailable == false) {
                                Get.snackbar("Thông báo",
                                    "Khuyến mãi không khả dụng tại thời gian này");
                                return;
                              } else if (item.type ==
                                  PromotionTypeEnums.AUTOAPPLY) {
                                Get.snackbar("Thông báo",
                                    "Khuyến mãi này được áp dụng tự động");
                                return;
                              } else {
                                (model.selectedPromotion != null &&
                                        model.selectedPromotion?.id == item.id)
                                    ? model.removePromotion()
                                    : model.checkPromotion(item);
                              }
                            },
                            child: Card(
                              color: item.isAvailable == false
                                  ? Get.theme.colorScheme.errorContainer
                                  : (model.selectedPromotion != null &&
                                          model.selectedPromotion?.id ==
                                              item.id)
                                      ? Get.theme.colorScheme.primaryContainer
                                      : Get.theme.colorScheme.background,
                              child: SizedBox(
                                width: 360,
                                height: 240,
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
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Chip(
                                            label: Text(
                                              "${formatTimeOnly(item.startTime ?? '')} - ${formatTimeOnly(item.endTime ?? '')}",
                                              style: Get.textTheme.labelSmall,
                                            ),
                                          ),
                                          Chip(
                                            backgroundColor:
                                                item.isAvailable == true
                                                    ? Get.theme.colorScheme
                                                        .primaryContainer
                                                    : Get.theme.colorScheme
                                                        .background,
                                            label: Text(
                                              item.isAvailable ?? false
                                                  ? "Khả dụng"
                                                  : "Tạm ẩn",
                                              style: Get.textTheme.labelSmall,
                                            ),
                                          ),
                                          Chip(
                                            backgroundColor:
                                                item.isAvailable == true
                                                    ? Get.theme.colorScheme
                                                        .primaryContainer
                                                    : Get.theme.colorScheme
                                                        .background,
                                            label: Text(
                                              item.type ==
                                                      PromotionTypeEnums.AMOUNT
                                                  ? "Giảm ${formatPrice(item.discountAmount ?? 0)}"
                                                  : item.type ==
                                                          PromotionTypeEnums
                                                              .PERCENT
                                                      ? "Giảm ${percentCalculation(item.discountPercent ?? 0)}"
                                                      : item.type ==
                                                              PromotionTypeEnums
                                                                  .PRODUCT
                                                          ? "Giảm sản phẩm"
                                                          : "Tự động giảm",
                                              style: Get.textTheme.labelSmall,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
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
    );
  }
}

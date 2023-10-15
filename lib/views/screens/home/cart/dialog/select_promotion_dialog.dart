import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/pointify/promotion_model.dart';
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
            return DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: Scaffold(
                  appBar: TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(Icons.discount),
                        text: "Khuyến mãi",
                      ),
                      Tab(
                        icon: Icon(Icons.wallet_membership),
                        text: "Thành viên",
                      ),
                      Tab(
                        icon: Icon(Icons.payment),
                        text: "Thanh toán",
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Wrap(
                          children: [
                            for (PromotionPointify item in model.promotions!)
                              InkWell(
                                onTap: () {
                                  // if (item.isAvailable == false) {
                                  //   Get.snackbar("Thông báo",
                                  //       "Khuyến mãi không khả dụng tại thời gian này");
                                  //   return;
                                  // } else if (item.type ==
                                  //     PromotionTypeEnums.AUTOAPPLY) {
                                  //   Get.snackbar("Thông báo",
                                  //       "Khuyến mãi này được áp dụng tự động");
                                  //   return;
                                  // } else {
                                  //   (model.isPromotionApplied(item.id ?? ''))
                                  //       ? model.removePromotion(item.id ?? '')
                                  //       : model.checkPromotion(item);
                                  // }
                                },
                                child: Card(
                                  // color: item.isAvailable == false
                                  //     ? Get.theme.colorScheme.errorContainer
                                  //     : model.isPromotionApplied(item.id ?? '')
                                  //         ? Get.theme.colorScheme.primaryContainer
                                  //         : Get.theme.colorScheme.background,
                                  child: SizedBox(
                                    width: 360,
                                    height: 240,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                item.promotionName ?? '',
                                                style:
                                                    Get.textTheme.titleMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(item.description ?? ''),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              model.isPromotionApplied(
                                                      item.promotionId ?? '')
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              model.decreasePromotionQuantity(
                                                                  item.promotionId!);
                                                            },
                                                            icon: Icon(
                                                              Icons.remove,
                                                              size: 48,
                                                            )),
                                                        Text(
                                                            "${model.selectedPromotion(item.promotionId!)!.quantity ?? 1}",
                                                            style: Get.textTheme
                                                                .titleLarge),
                                                        IconButton(
                                                            onPressed: () {
                                                              model.increasePromotionQuantity(
                                                                  item.promotionId!);
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                              size: 48,
                                                            )),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceAround,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.center,
                                              //   children: [
                                              //     Chip(
                                              //       label: Text(
                                              //         "${formatTimeOnly(item.startTime ?? '')} - ${formatTimeOnly(item.endTime ?? '')}",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     ),
                                              //     Chip(
                                              //       backgroundColor:
                                              //           item.isAvailable == true
                                              //               ? Get.theme.colorScheme
                                              //                   .primaryContainer
                                              //               : Get.theme.colorScheme
                                              //                   .background,
                                              //       label: Text(
                                              //         item.isAvailable ?? false
                                              //             ? "Khả dụng"
                                              //             : "Tạm ẩn",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     ),
                                              //     Chip(
                                              //       backgroundColor:
                                              //           item.isAvailable == true
                                              //               ? Get.theme.colorScheme
                                              //                   .primaryContainer
                                              //               : Get.theme.colorScheme
                                              //                   .background,
                                              //       label: Text(
                                              //         item.type ==
                                              //                 PromotionTypeEnums
                                              //                     .AMOUNT
                                              //             ? "Giảm ${formatPrice(item.discountAmount ?? 0)}"
                                              //             : item.type ==
                                              //                     PromotionTypeEnums
                                              //                         .PERCENT
                                              //                 ? "Giảm ${percentCalculation(item.discountPercent ?? 0)}"
                                              //                 : item.type ==
                                              //                         PromotionTypeEnums
                                              //                             .PRODUCT
                                              //                     ? "Giảm sản phẩm"
                                              //                     : "Tự động giảm",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     )
                                              //   ],
                                              // ),
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
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: TextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintText:
                                          "Nhập thẻ thành viên hoặc số điện thoại",
                                      hintStyle: Get.textTheme.bodyMedium,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      filled: true,
                                      isDense: true,
                                      labelStyle: Get.textTheme.labelLarge,
                                      fillColor:
                                          Get.theme.colorScheme.background,
                                      prefixIcon: Icon(
                                        Icons.portrait_rounded,
                                        color:
                                            Get.theme.colorScheme.onBackground,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.clear),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Get.theme.colorScheme
                                                  .primaryContainer,
                                              width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Get.theme.colorScheme
                                                  .primaryContainer,
                                              width: 2.0)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color: Get.theme.colorScheme
                                                  .primaryContainer,
                                              width: 2.0)),
                                      contentPadding: EdgeInsets.all(16),
                                      isCollapsed: true,
                                      errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          borderSide: BorderSide(
                                              color:
                                                  Get.theme.colorScheme.error,
                                              width: 2.0))),
                                )),
                                Container(
                                  width: 70,
                                  padding: EdgeInsets.all(8),
                                  child: DropdownButton(
                                      isDense: true,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      items: const [
                                        DropdownMenuItem(
                                            child: Text("sdt"), value: 1),
                                        DropdownMenuItem(
                                            child: Text("sdt"), value: 2)
                                      ],
                                      onChanged: (value) {}),
                                ),
                                OutlinedButton(
                                    onPressed: () => {}, child: Text("Tìm"))
                              ],
                            ),
                          ],
                        ),
                      )),
                      SingleChildScrollView(
                        child: Wrap(
                          children: [
                            for (PromotionPointify item in model.promotions!)
                              InkWell(
                                onTap: () {
                                  // if (item.isAvailable == false) {
                                  //   Get.snackbar("Thông báo",
                                  //       "Khuyến mãi không khả dụng tại thời gian này");
                                  //   return;
                                  // } else if (item.type ==
                                  //     PromotionTypeEnums.AUTOAPPLY) {
                                  //   Get.snackbar("Thông báo",
                                  //       "Khuyến mãi này được áp dụng tự động");
                                  //   return;
                                  // } else {
                                  //   (model.isPromotionApplied(item.id ?? ''))
                                  //       ? model.removePromotion(item.id ?? '')
                                  //       : model.checkPromotion(item);
                                  // }
                                },
                                child: Card(
                                  // color: item.isAvailable == false
                                  //     ? Get.theme.colorScheme.errorContainer
                                  //     : model.isPromotionApplied(item.id ?? '')
                                  //         ? Get.theme.colorScheme.primaryContainer
                                  //         : Get.theme.colorScheme.background,
                                  child: SizedBox(
                                    width: 360,
                                    height: 240,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                item.promotionName ?? '',
                                                style:
                                                    Get.textTheme.titleMedium,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Divider(),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child:
                                                  Text(item.description ?? ''),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              model.isPromotionApplied(
                                                      item.promotionId ?? '')
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              model.decreasePromotionQuantity(
                                                                  item.promotionId!);
                                                            },
                                                            icon: Icon(
                                                              Icons.remove,
                                                              size: 48,
                                                            )),
                                                        Text(
                                                            "${model.selectedPromotion(item.promotionId!)!.quantity ?? 1}",
                                                            style: Get.textTheme
                                                                .titleLarge),
                                                        IconButton(
                                                            onPressed: () {
                                                              model.increasePromotionQuantity(
                                                                  item.promotionId!);
                                                            },
                                                            icon: Icon(
                                                              Icons.add,
                                                              size: 48,
                                                            )),
                                                      ],
                                                    )
                                                  : SizedBox(),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.spaceAround,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.center,
                                              //   children: [
                                              //     Chip(
                                              //       label: Text(
                                              //         "${formatTimeOnly(item.startTime ?? '')} - ${formatTimeOnly(item.endTime ?? '')}",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     ),
                                              //     Chip(
                                              //       backgroundColor:
                                              //           item.isAvailable == true
                                              //               ? Get.theme.colorScheme
                                              //                   .primaryContainer
                                              //               : Get.theme.colorScheme
                                              //                   .background,
                                              //       label: Text(
                                              //         item.isAvailable ?? false
                                              //             ? "Khả dụng"
                                              //             : "Tạm ẩn",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     ),
                                              //     Chip(
                                              //       backgroundColor:
                                              //           item.isAvailable == true
                                              //               ? Get.theme.colorScheme
                                              //                   .primaryContainer
                                              //               : Get.theme.colorScheme
                                              //                   .background,
                                              //       label: Text(
                                              //         item.type ==
                                              //                 PromotionTypeEnums
                                              //                     .AMOUNT
                                              //             ? "Giảm ${formatPrice(item.discountAmount ?? 0)}"
                                              //             : item.type ==
                                              //                     PromotionTypeEnums
                                              //                         .PERCENT
                                              //                 ? "Giảm ${percentCalculation(item.discountPercent ?? 0)}"
                                              //                 : item.type ==
                                              //                         PromotionTypeEnums
                                              //                             .PRODUCT
                                              //                     ? "Giảm sản phẩm"
                                              //                     : "Tự động giảm",
                                              //         style:
                                              //             Get.textTheme.labelSmall,
                                              //       ),
                                              //     )
                                              //   ],
                                              // ),
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
                    ],
                  ),
                  floatingActionButton: OutlinedButton(
                    onPressed: () {
                      hideDialog();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Đóng"),
                    ),
                  ),
                  // IconButton(
                  //     iconSize: 40,
                  //     onPressed: () => Get.back(),
                  //     icon: Icon(Icons.close)),
                ));
          },
        ),
      ),
    );
  }
}

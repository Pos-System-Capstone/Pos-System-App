import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/cart_model.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../widgets/other_dialogs/dialog.dart';
import 'dialog/choose_deli_type_dialog.dart';
import 'dialog/choose_table_dialog.dart';
import 'dialog/select_promotion_dialog.dart';
import 'dialog/update_cart_item_dialog.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<CartViewModel>(
      model: Get.find<CartViewModel>(),
      child: ScopedModelDescendant<CartViewModel>(
          builder: (context, child, model) {
        int selectedTable = Get.find<OrderViewModel>().selectedTable;
        String selectedDeliType = Get.find<OrderViewModel>().deliveryType;
        dynamic selectedDeliLable = showOrderType(selectedDeliType);
        if (model.status == ViewStatus.Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.onInverseSurface,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        'Tên',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'SL',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Tổng',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Get.theme.colorScheme.onSurface,
                thickness: 1,
              ),
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: model.cart.productList!.length,
                physics: ScrollPhysics(),
                itemBuilder: (context, i) {
                  return cartItem(model.cart.productList![i], i);
                },
              )),
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Divider(
                      thickness: 1,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Số lượng: ${model.countCartQuantity().toString()}',
                              style: Get.textTheme.bodyMedium),
                          Text(
                              'Tạm tính: ${formatPrice(model.cart.totalAmount ?? 0)}',
                              style: Get.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    model.cart.promotionList!.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.cart.promotionList!.length,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "-${model.cart.promotionList![i].name}",
                                      style: Get.textTheme.bodySmall,
                                    ),
                                    Text(
                                      model.cart.promotionList![i].effectType ==
                                              "GET_POINT"
                                          ? "+${model.cart.promotionList![i].discountAmount} Điểm"
                                          : ("-${formatPrice(model.cart.promotionList![i].discountAmount!)}"),
                                      style: Get.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              'Tổng giảm: ${formatPrice(model.cart.discountAmount ?? 0)}',
                              style: Get.textTheme.bodyMedium),
                          Text(
                              'Tổng tiền: ${formatPrice(model.cart.finalAmount ?? 0)}',
                              style: Get.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    Divider(
                      color: Get.theme.colorScheme.onSurface,
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FilledButton.tonal(
                            onPressed: () => chooseTableDialog(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Text(
                                'Bàn $selectedTable',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          FilledButton.tonal(
                            onPressed: () => chooseDeliTypeDialog(),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Text(
                                '${selectedDeliLable.label}',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () async {
                                selectPromotionDialog();
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Text(
                                  'Giảm giá',
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Get.theme.colorScheme.onSurface,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: IconButton(
                                onPressed: () async {
                                  var result = await showConfirmDialog(
                                      title: 'Xác nhận',
                                      content:
                                          'Bạn có chắc chắn muốn xóa toàn bộ giỏ hàng không?');
                                  if (result) {
                                    model.clearCartData();
                                  }
                                },
                                icon: Icon(
                                  Icons.delete_outlined,
                                  size: 40,
                                )),
                          ),
                          Expanded(
                            child: FilledButton(
                              onPressed: () async {
                                if (model.countCartQuantity() == 0) {
                                  showAlertDialog(
                                    title: 'Thông báo',
                                    content: 'Giỏ hàng trống',
                                  );
                                  return;
                                } else {
                                  model.createOrder();
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 12, 0, 12),
                                child: Text(
                                  'Tạo đơn hàng',
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      color: Get.theme.colorScheme.background),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget cartItem(ProductList item, int index) {
    return InkWell(
      onTap: () =>
          {Get.dialog(UpdateCartItemDialog(cartItem: item, idx: index))},
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name!,
                        style: Get.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatPrice(item.sellingPrice!),
                            style: Get.textTheme.bodyMedium,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${item.quantity}",
                        style: Get.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Column(
                      children: [
                        Text(
                          formatPrice(item.finalAmount ?? 0),
                          style: Get.textTheme.bodyMedium,
                        ),
                        item.discount != null && item.discount != 0
                            ? Text(
                                "-${formatPrice(item.discount ?? 0)}",
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: item.extras?.length,
              physics: ScrollPhysics(),
              itemBuilder: (context, i) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        " +${item.extras![i].name!}",
                        style: Get.textTheme.bodySmall,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "${item.extras![i].quantity}",
                            style: Get.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          "+${formatPrice(item.extras![i].totalAmount!)}",
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  children: [
                    if (item.attributes != null)
                      for (int i = 0; i < item.attributes!.length; i++)
                        Text("${item.attributes![i].value} ",
                            style: Get.textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                    Text(item.note ?? '',
                        style: Get.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

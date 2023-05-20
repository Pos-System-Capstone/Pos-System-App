import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 7,
                        child: Text(
                          'Tên',
                          style: Get.textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          'SL',
                          style: Get.textTheme.titleMedium,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Tổng',
                            style: Get.textTheme.titleMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Get.theme.colorScheme.onSurface,
                thickness: 1,
              ),
              Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: model.cartList.length,
                physics: ScrollPhysics(),
                itemBuilder: (context, i) {
                  return cartItem(model.cartList[i], i);
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
                          Text('Số lượng', style: Get.textTheme.titleSmall),
                          Text(model.quantity.toString(),
                              style: Get.textTheme.titleSmall),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tạm tính', style: Get.textTheme.titleSmall),
                          Text(formatPrice(model.totalAmount ?? 0),
                              style: Get.textTheme.titleSmall),
                        ],
                      ),
                    ),
                    model.productDiscount! > 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Giảm giá SP",
                                    style: Get.textTheme.titleSmall),
                                Text(
                                    "-${formatPrice(model.productDiscount ?? 0)}",
                                    style: Get.textTheme.titleSmall),
                              ],
                            ),
                          )
                        : SizedBox(),
                    model.discountAmount! > 0
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(model.selectedPromotion?.name ?? "",
                                    style: Get.textTheme.titleSmall),
                                Text(
                                    "-${formatPrice(model.discountAmount ?? 0)}",
                                    style: Get.textTheme.titleSmall),
                              ],
                            ),
                          )
                        : SizedBox(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng tiền', style: Get.textTheme.titleMedium),
                          Text(formatPrice(model.finalAmount),
                              style: Get.textTheme.titleMedium),
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
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                if (model.quantity == 0) {
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

  Widget cartItem(CartItem item, int index) {
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
                        item.product.name!,
                        style: Get.textTheme.bodyLarge,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            formatPrice(item.product.sellingPrice!),
                            style: Get.textTheme.bodyLarge,
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
                        style: Get.textTheme.bodyLarge,
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
                          formatPrice(item.totalAmount),
                          style: Get.textTheme.bodyLarge,
                        ),
                        item.product.discountPrice != null &&
                                item.product.discountPrice != 0
                            ? Text(
                                "-${formatPrice(item.product.discountPrice! * item.quantity)}",
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
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          "+${item.extras![i].name!}",
                          style: Get.textTheme.bodyMedium,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            formatPrice(item.extras![i].sellingPrice!),
                            style: Get.textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
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

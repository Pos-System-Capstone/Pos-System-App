import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../view_model/cart_view_model.dart';
import 'update_cart_item_dialog.dart';

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
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.onInverseSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Row(
                          textDirection: TextDirection.ltr,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Bàn: $selectedTable',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                'Tại quầy',
                                style: Get.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
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
                    ],
                  ),
                ),
                Expanded(
                    flex: 7,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.cartList.length,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, i) {
                        return cartItem(model.cartList[i], i);
                      },
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Get.theme.colorScheme.onInverseSurface,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Số lượng',
                                  style: Get.textTheme.titleMedium),
                              Text(model.quantity.toString(),
                                  style: Get.textTheme.titleMedium),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tổng tiền',
                                  style: Get.textTheme.titleMedium),
                              Text(formatPrice(model.totalAmount),
                                  style: Get.textTheme.titleMedium),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    onPressed: () =>
                                        {model.clearCartData(), Get.back()},
                                    icon: Icon(
                                      Icons.delete_outlined,
                                      size: 32,
                                    )),
                              ),
                              Expanded(
                                flex: 4,
                                child: FilledButton.icon(
                                  onPressed: () => {model.createOrder()},
                                  icon: Icon(Icons.payment),
                                  label: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Thanh toán',
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.colorScheme
                                                  .background),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
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
                        style: Get.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                      ),
                      Text(
                        formatPrice(item.product.sellingPrice!),
                        style: Get.textTheme.bodySmall,
                      ),
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
                      // Text(
                      //   "Xóa",
                      //   style: Get.textTheme.bodyMedium,
                      //   textAlign: TextAlign.right,
                      // ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      formatPrice(item.totalAmount!),
                      style: Get.textTheme.bodyMedium,
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
                          item.extras![i].name!,
                          style: Get.textTheme.bodySmall,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: Text(
                            formatPrice(item.extras![i].sellingPrice!),
                            style: Get.textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(
              color: Get.theme.colorScheme.onSurface,
              thickness: 0.5,
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../util/format.dart';
import '../../../../view_model/index.dart';
import '../../../widgets/other_dialogs/dialog.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OrderViewModel>(
        builder: (context, build, model) {
      if (model.status == ViewStatus.Loading || model.currentOrder == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Thông tin thanh toán',
                          style: Get.textTheme.titleLarge,
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: model.currentOrder!.productList!.length,
                        physics: ScrollPhysics(),
                        itemBuilder: (context, i) {
                          return productItem(
                              model.currentOrder!.productList![i]);
                        },
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Mã đơn',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              model.currentOrder!.invoiceId!,
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Bàn',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              model.selectedTable.toString(),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nhận món',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              showOrderType(model.currentOrder!.orderType!)
                                  .label,
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Khách hàng',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              'Người dùng',
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Trạng thái',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              showOrderStatus(
                                  model.currentOrder!.orderStatus ?? ""),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Thanh toán',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              model.selectedPaymentMethod!.name ?? "Tiền mặt",
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Thời gian',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatTime(model.currentOrder?.checkInDate ?? ""),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tạm tính',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatPrice(model.currentOrder!.totalAmount!),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      model.currentOrder!.discount != null &&
                              model.currentOrder!.discount != 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${model.currentOrder!.discountName}",
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    " - ${formatPrice(model.currentOrder!.discountPromotion ?? 0)}",
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      model.currentOrder!.discountProduct != null &&
                              model.currentOrder!.discountProduct != 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Giảm giá sản phẩm" ?? '',
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                  Text(
                                    " - ${formatPrice(model.currentOrder!.discountProduct ?? 0)}",
                                    style: Get.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'VAT (${percentCalculation(model.currentOrder!.vat!)})',
                              style: Get.textTheme.bodyMedium,
                            ),
                            Text(
                              formatPrice(model.currentOrder!.vatAmount!),
                              style: Get.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Tổng tiền',
                              style: Get.textTheme.titleMedium,
                            ),
                            Text(
                              formatPrice(model.currentOrder!.finalAmount!),
                              style: Get.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Get.theme.colorScheme.onSurface,
                        thickness: 1,
                      ),
                      model.customerMoney > 0
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Khách đưa',
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  Text(
                                    formatPrice(model.customerMoney),
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      model.customerMoney >= model.currentOrder!.finalAmount!
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Trả lại',
                                    style: Get.textTheme.titleMedium,
                                  ),
                                  Text(
                                    formatPrice(model.returnMoney),
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(8.0),
            //   width: double.infinity,
            //   height: 64,
            //   child: FilledButton.icon(
            //     onPressed: () async {
            //       var result = await showConfirmDialog(
            //           title: 'Xác nhận',
            //           content: 'Xác nhận hoàn thành đơn hàng');
            //       if (result) {
            //         model.completeOrder(
            //           model.currentOrder!.orderId!,
            //         );
            //       }
            //     },
            //     icon: Icon(Icons.check),
            //     label: Text(
            //       'Hoàn thành',
            //       style: Get.textTheme.titleMedium
            //           ?.copyWith(color: Get.theme.colorScheme.background),
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}

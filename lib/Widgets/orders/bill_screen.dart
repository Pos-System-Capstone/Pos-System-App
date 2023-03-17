import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../util/format.dart';
import '../../view_model/index.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant(
            builder: (context, child, OrderViewModel model) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Expanded(
                            child: Text(
                              'Thông tin thanh toán',
                              style: Get.textTheme.titleMedium,
                            ),
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
                                'Mã đơn',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.orderResponseModel!.invoiceId!,
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
                                'User',
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
                                model.orderResponseModel!.payment!.paymentType!,
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
                                formatTime(
                                    model.orderResponseModel!.checkInDate!),
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
                                formatPrice(
                                    model.orderResponseModel!.totalAmount!),
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
                                'Giảm giá',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                " - ${formatPrice(model.orderResponseModel!.discount!)}",
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
                                '%VAT',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.orderResponseModel!.vat!.toString() +
                                    ' %',
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
                                'VAT',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatPrice(
                                    model.orderResponseModel!.vatAmount!),
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
                                formatPrice(
                                    model.orderResponseModel!.finalAmount!),
                                style: Get.textTheme.titleMedium,
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
                                'Khách đưa',
                                style: Get.textTheme.titleMedium,
                              ),
                              Text(
                                formatPrice(
                                    model.orderResponseModel!.finalAmount!),
                                style: Get.textTheme.titleMedium,
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
                                'Trả lại',
                                style: Get.textTheme.titleMedium,
                              ),
                              Text(
                                formatPrice(
                                    model.orderResponseModel!.finalAmount!),
                                style: Get.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => {},
                              icon: Icon(Icons.cancel_outlined),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Huỷ đơn hàng',
                                  style: Get.textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Get.theme.colorScheme.onSurface,
                          thickness: 1,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => {null},
                              icon: Icon(Icons.check),
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Hoan thành',
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      color: Get.theme.colorScheme.background),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
          ;
        }));
  }
}

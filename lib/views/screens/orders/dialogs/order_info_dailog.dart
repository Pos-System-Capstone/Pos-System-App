import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../enums/order_enum.dart';
import '../../../../enums/view_status.dart';
import '../../../../util/format.dart';
import '../../../widgets/other_dialogs/dialog.dart';

void orderInfoDialog(String orderId) {
  hideDialog();
  Get.find<OrderViewModel>().getOrderByStore(orderId);
  Get.dialog(Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
            builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return Container(
              width: Get.size.width * 0.8,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Đang xử lý...",
                    style: Get.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          } else if (model.currentOrder == null) {
            return Container(
              width: Get.size.width * 0.8,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Không tìm thấy đơn hàng",
                    style: Get.textTheme.titleLarge,
                  ),
                ],
              ),
            );
          }
          return Container(
              width: Get.size.width * 0.6,
              height: Get.size.height * 0.8,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.colorScheme.shadow,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Thông tin đơn hàng",
                            style: Get.textTheme.titleMedium,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            hideDialog();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Get.theme.colorScheme.onBackground,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Get.theme.colorScheme.onBackground,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
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
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Mã',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.currentOrder!.invoiceId ?? "",
                                style: Get.textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          Row(
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
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
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
                          Row(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Phuơng thức',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                model.getPaymentName(
                                    model.currentOrder!.paymentType!),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Thời gian',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatTime(
                                    model.currentOrder!.checkInDate ?? ""),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
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
                          model.currentOrder!.discount != null &&
                                  model.currentOrder!.discount != 0
                              ? Row(
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
                                )
                              : SizedBox(),
                          model.currentOrder!.discountProduct != null &&
                                  model.currentOrder!.discountProduct != 0
                              ? Row(
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
                                )
                              : SizedBox(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'VAT(${percentCalculation(model.currentOrder!.vat!)})',
                                style: Get.textTheme.bodyMedium,
                              ),
                              Text(
                                formatPrice(model.currentOrder!.vatAmount ?? 0),
                                style: Get.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          Divider(
                            color: Get.theme.colorScheme.onSurface,
                            thickness: 1,
                          ),
                          Row(
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
                        ],
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Get.find<PrinterViewModel>().printBill(
                          model.currentOrder!,
                          model.selectedTable,
                          model.getPaymentName(
                              model.currentOrder!.paymentType!));
                    },
                    child: Text(
                      'In hoá đơn',
                    ),
                  ),
                ],
              ));
        }),
      )));
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../data/model/response/order_response.dart';
import '../../../../enums/order_enum.dart';
import '../../../../enums/view_status.dart';
import '../../../../util/format.dart';
import '../../../widgets/other_dialogs/dialog.dart';

const double _dialogPadding = 16.0;
const double _sectionSpacing = 12.0;
const double _itemPadding = 8.0;

void orderInfoDialog(String orderId) {
  hideDialog();
  Get.find<OrderViewModel>().getOrderByStore(orderId);
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ScopedModel(
        model: Get.find<OrderViewModel>(),
        child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, child, model) {
            if (model.status == ViewStatus.Loading) {
              return _buildLoadingState();
            } else if (model.currentOrder == null) {
              return _buildErrorState();
            }
            return _buildOrderInfoContent(model);
          },
        ),
      ),
    ),
  );
}

Widget _buildLoadingState() {
  return Container(
    width: Get.size.width * 0.8,
    height: Get.size.height * 0.8,
    padding: EdgeInsets.all(_dialogPadding),
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Get.theme.colorScheme.shadow.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text(
          "Đang tải thông tin đơn hàng...",
          style: Get.textTheme.bodyLarge,
        ),
      ],
    ),
  );
}

Widget _buildErrorState() {
  return Container(
    width: Get.size.width * 0.8,
    height: Get.size.height * 0.4,
    padding: EdgeInsets.all(_dialogPadding),
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Get.theme.colorScheme.shadow.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline,
          size: 48,
          color: Get.theme.colorScheme.error,
        ),
        SizedBox(height: 16),
        Text(
          "Không tìm thấy đơn hàng",
          style: Get.textTheme.titleMedium,
        ),
        SizedBox(height: 24),
        FilledButton(
          onPressed: () => hideDialog(),
          child: Text("Đóng"),
        ),
      ],
    ),
  );
}

Widget _buildOrderInfoContent(OrderViewModel model) {
  return Container(
    width: Get.size.width * 0.8,
    height: Get.size.height * 0.8,
    decoration: BoxDecoration(
      color: Get.theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Get.theme.colorScheme.shadow.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        _buildDialogHeader(),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _dialogPadding,
                vertical: _sectionSpacing,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductListSection(model),
                  SizedBox(height: _sectionSpacing),
                  _buildOrderDetailsSection(model),
                  SizedBox(height: _sectionSpacing),
                  _buildCustomerSection(model),
                  SizedBox(height: _sectionSpacing),
                  _buildPriceSummarySection(model),
                ],
              ),
            ),
          ),
        ),
        _buildFooterActions(model),
      ],
    ),
  );
}

Widget _buildDialogHeader() {
  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: _dialogPadding,
      vertical: _sectionSpacing,
    ),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Get.theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Thông tin đơn hàng",
          style: Get.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => hideDialog(),
          icon: Icon(Icons.close),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Get.theme.colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildProductListSection(OrderViewModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Sản phẩm",
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: _sectionSpacing),
      Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(_itemPadding),
              child: Row(
                children: [
                  Expanded(
                    flex: 7,
                    child: Text(
                      'Tên sản phẩm',
                      style: Get.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'SL',
                      style: Get.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      'Tổng',
                      style: Get.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: Get.theme.colorScheme.outlineVariant,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: model.currentOrder!.productList!.length,
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (context, i) => Divider(
                height: 1,
                color: Get.theme.colorScheme.outlineVariant,
              ),
              itemBuilder: (context, i) => productItem(
                model.currentOrder!.productList![i],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildOrderDetailsSection(OrderViewModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Chi tiết đơn hàng",
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: _sectionSpacing),
      _InfoRow("Mã đơn", model.currentOrder!.invoiceId ?? ""),
      _InfoRow(
          "Số thứ tự", (model.currentOrder?.customerNumber ?? 1).toString()),
      _InfoRow(
        "Nhận món",
        showOrderType(model.currentOrder!.orderType!).label,
      ),
      _InfoRow("Ghi chú", model.currentOrder?.notes ?? "Không có"),
      _InfoRow(
        "Trạng thái",
        showOrderStatus(model.currentOrder!.orderStatus ?? ""),
      ),
      _InfoRow(
        "Thời gian",
        formatTime(model.currentOrder!.checkInDate ?? ""),
      ),
    ],
  );
}

Widget _buildCustomerSection(OrderViewModel model) {
  final info = model.currentOrder?.customerInfo;
  if (info == null) return SizedBox();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Thông tin khách hàng",
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: _sectionSpacing),
      _InfoRow("Khách hàng", info.name ?? "Khách"),
      _InfoRow("Số điện thoại", info.phone ?? ""),
      _InfoRow("Nhận món lúc", info.deliTime ?? ""),
      _InfoRow("Địa chỉ giao", info.address ?? ""),
    ],
  );
}

Widget _buildPriceSummarySection(OrderViewModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Tổng hợp giá",
        style: Get.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: _sectionSpacing),
      Container(
        padding: EdgeInsets.all(_itemPadding),
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PriceRow(
              "Tạm tính",
              formatPrice(model.currentOrder!.totalAmount!),
              isBold: false,
            ),
            if (model.currentOrder!.promotionList != null &&
                model.currentOrder!.promotionList!.isNotEmpty) ...[
              SizedBox(height: 8),
              ...List.generate(
                model.currentOrder!.promotionList!.length,
                (i) {
                  final promo = model.currentOrder!.promotionList![i];
                  final displayValue = promo.effectType == "GET_POINT"
                      ? "+${promo.discountAmount} Điểm"
                      : "- ${formatPrice(promo.discountAmount ?? 0)}";
                  return _PriceRow(
                    promo.promotionName ?? "Khuyến mãi",
                    displayValue,
                    isBold: false,
                    isDiscount: true,
                  );
                },
              ),
            ],
            if (model.currentOrder!.discount != 0) ...[
              SizedBox(height: 8),
              _PriceRow(
                "Tổng giảm giá",
                " - ${formatPrice(model.currentOrder!.discount!)}",
                isBold: false,
                isDiscount: true,
              ),
            ],
            Divider(
              color: Get.theme.colorScheme.outline,
              height: 16,
            ),
            _PriceRow(
              "Tổng tiền",
              formatPrice(model.currentOrder!.finalAmount!),
              isBold: true,
              isTotal: true,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildFooterActions(OrderViewModel model) {
  return Container(
    padding: EdgeInsets.all(_dialogPadding),
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
          color: Get.theme.colorScheme.outlineVariant,
          width: 1,
        ),
      ),
    ),
    child: SizedBox(
      width: double.infinity,
      height: 48,
      child: FilledButton.icon(
        onPressed: () {
          Get.find<PrinterViewModel>().printBill(
            model.currentOrder!,
            model.getPaymentName(model.currentOrder!.paymentType!),
          );
        },
        icon: Icon(Icons.print),
        label: Text("In hoá đơn"),
      ),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: _itemPadding / 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;
  final bool isTotal;

  const _PriceRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.isDiscount = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                (isTotal ? Get.textTheme.titleMedium : Get.textTheme.bodyMedium)
                    ?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount
                  ? Get.theme.colorScheme.error
                  : Get.theme.colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style:
                (isTotal ? Get.textTheme.titleMedium : Get.textTheme.bodyMedium)
                    ?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Get.theme.colorScheme.error
                  : isTotal
                      ? Get.theme.colorScheme.primary
                      : Get.theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

Widget customerInfo(CustomerInfo? info) {
  if (info == null) {
    return SizedBox();
  }
  return Column(
    children: [
      _InfoRow("Khách hàng", info.name ?? "Khách"),
      _InfoRow("SDT", info.phone ?? ""),
      _InfoRow("Nhận món lúc", info.deliTime ?? ""),
      _InfoRow("Địa chỉ giao", info.address ?? ""),
    ],
  );
}

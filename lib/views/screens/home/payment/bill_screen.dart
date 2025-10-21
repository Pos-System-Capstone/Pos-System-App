import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../data/model/response/order_response.dart';
import '../../../../util/format.dart';
import '../../../../view_model/index.dart';
import '../../../widgets/other_dialogs/dialog.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  static const double _horizontalPadding = 12.0;
  static const double _verticalSpacing = 12.0;
  static const double _sectionPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OrderViewModel>(
      builder: (context, build, model) {
        if (model.status == ViewStatus.Loading || model.currentOrder == null) {
          return Center(child: CircularProgressIndicator());
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
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        _buildProductSection(model),
                        _buildOrderDetailsSection(model),
                        _buildCustomerSection(model),
                        _buildPriceSummarySection(model),
                        SizedBox(height: _verticalSpacing),
                      ],
                    ),
                  ),
                ),
              ),
              _buildPrintButton(model),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(_horizontalPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.receipt_long,
            size: 28,
            color: Get.theme.colorScheme.primary,
          ),
          SizedBox(width: _horizontalPadding),
          Text(
            'Thông tin thanh toán',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _horizontalPadding,
        _verticalSpacing,
        _horizontalPadding,
        _sectionPadding,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: Get.theme.colorScheme.primary,
            ),
            SizedBox(width: 8),
          ],
          Text(
            title,
            style: Get.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Get.theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Divider(
        color: Get.theme.colorScheme.outlineVariant,
        thickness: 1,
        height: _verticalSpacing,
      ),
    );
  }

  Widget _buildProductSection(OrderViewModel model) {
    return Column(
      children: [
        _buildSectionHeader("Sản phẩm", icon: Icons.shopping_bag),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(_horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Tổng',
                            style: Get.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Get.theme.colorScheme.outlineVariant,
                  thickness: 1,
                  height: 1,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: model.currentOrder!.productList!.length,
                  physics: NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, i) => Divider(
                    color: Get.theme.colorScheme.outlineVariant,
                    thickness: 0.5,
                    height: 1,
                  ),
                  itemBuilder: (context, i) => Padding(
                    padding: EdgeInsets.all(_horizontalPadding),
                    child: productItem(model.currentOrder!.productList![i]),
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildOrderDetailsSection(OrderViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Chi tiết đơn hàng", icon: Icons.info),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            padding: EdgeInsets.all(_horizontalPadding),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _InfoRow('Mã đơn', model.currentOrder!.invoiceId!),
                _InfoRow('Số thứ tự',
                    (model.currentOrder?.customerNumber ?? 1).toString()),
                _InfoRow(
                  'Nhận món',
                  showOrderType(model.currentOrder!.orderType!).label,
                ),
                _InfoRow('Ghi chú', model.currentOrder?.notes ?? 'Không có'),
              ],
            ),
          ),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildCustomerSection(OrderViewModel model) {
    final hasCustomerInfo = model.currentOrder?.customerInfo != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Thông tin khách hàng", icon: Icons.person),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            padding: EdgeInsets.all(_horizontalPadding),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                if (hasCustomerInfo) ...[
                  customerInfo(model.currentOrder?.customerInfo),
                ] else ...[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: _horizontalPadding),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          color: Get.theme.colorScheme.outlineVariant,
                        ),
                        SizedBox(width: _horizontalPadding),
                        Text(
                          'Khách hàng: Khách',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Divider(
                  color: Get.theme.colorScheme.outlineVariant,
                  thickness: 0.5,
                ),
                _InfoRow(
                  'Trạng thái',
                  showOrderStatus(model.currentOrder!.orderStatus ?? ""),
                ),
                _InfoRow(
                  'Thanh toán',
                  model.selectedPaymentMethod!.name ?? "Tiền mặt",
                ),
                _InfoRow(
                  'Thời gian',
                  formatTime(model.currentOrder?.checkInDate ?? ""),
                ),
              ],
            ),
          ),
        ),
        _buildSectionDivider(),
      ],
    );
  }

  Widget _buildPriceSummarySection(OrderViewModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Tổng hợp giá", icon: Icons.attach_money),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Container(
            padding: EdgeInsets.all(_horizontalPadding),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PriceRow(
                  'Tạm tính',
                  formatPrice(model.currentOrder!.totalAmount!),
                  isBold: false,
                ),
                if (model.currentOrder!.promotionList != null &&
                    model.currentOrder!.promotionList!.isNotEmpty) ...[
                  SizedBox(height: _sectionPadding),
                  ...List.generate(
                    model.currentOrder!.promotionList!.length,
                    (i) {
                      final promo = model.currentOrder!.promotionList![i];
                      final displayValue = promo.effectType == "GET_POINT"
                          ? "+${promo.discountAmount} Điểm"
                          : "- ${formatPrice(promo.discountAmount ?? 0)}";
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: _PriceRow(
                          "🎁 ${promo.promotionName}",
                          displayValue,
                          isBold: false,
                          isDiscount: true,
                        ),
                      );
                    },
                  ),
                ],
                if (model.currentOrder!.discount != 0) ...[
                  SizedBox(height: _sectionPadding),
                  _PriceRow(
                    "Tổng giảm",
                    "- ${formatPrice(model.currentOrder!.discount ?? 0)}",
                    isBold: false,
                    isDiscount: true,
                  ),
                ],
                Divider(
                  color: Get.theme.colorScheme.outline,
                  height: _verticalSpacing,
                ),
                _PriceRow(
                  'Tổng tiền',
                  formatPrice(model.currentOrder!.finalAmount!),
                  isBold: true,
                  isTotal: true,
                ),
                if (model.customerMoney > 0) ...[
                  SizedBox(height: _sectionPadding),
                  _PriceRow(
                    'Khách đưa',
                    formatPrice(model.customerMoney),
                    isBold: true,
                  ),
                ],
                if (model.customerMoney >=
                    model.currentOrder!.finalAmount!) ...[
                  SizedBox(height: _sectionPadding),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: _horizontalPadding,
                      vertical: _sectionPadding,
                    ),
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: _PriceRow(
                      '↩️ Trả lại',
                      formatPrice(model.returnMoney),
                      isBold: true,
                      isReturn: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrintButton(OrderViewModel model) {
    return Container(
      padding: EdgeInsets.all(_horizontalPadding),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () =>
              Get.find<PrinterViewModel>().printBillDraft(model.currentOrder!),
          icon: Icon(Icons.print),
          label: Text("In hoá đơn tạm tính"),
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customerInfo(CustomerInfo? info) {
    if (info == null) {
      return SizedBox();
    }
    return Column(
      children: [
        _InfoRow('Khách hàng', info.name ?? "Khách"),
        _InfoRow('Số điện thoại', info.phone ?? ""),
        _InfoRow('Nhận món lúc', info.deliTime ?? ""),
        _InfoRow('Địa chỉ giao', info.address ?? ""),
        _InfoRow(
          'Trạng thái thanh toán',
          showPaymentStatusEnum(
            info.paymentStatus ?? PaymentStatusEnum.PENDING,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isSmall;

  const _InfoRow(
    this.label,
    this.value, {
    this.isTotal = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isSmall
        ? Get.textTheme.bodySmall
        : isTotal
            ? Get.textTheme.titleMedium
            : Get.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: textStyle?.copyWith(
                color: Get.theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textStyle?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
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
  final bool isReturn;

  const _PriceRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.isDiscount = false,
    this.isTotal = false,
    this.isReturn = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = isTotal
        ? Get.textTheme.titleMedium
        : isDiscount
            ? Get.textTheme.bodyMedium
            : Get.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: textStyle?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: isDiscount
                    ? Get.theme.colorScheme.error
                    : isTotal
                        ? Get.theme.colorScheme.onSurface
                        : Get.theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            value,
            style: textStyle?.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Get.theme.colorScheme.error
                  : isReturn
                      ? Get.theme.colorScheme.tertiary
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

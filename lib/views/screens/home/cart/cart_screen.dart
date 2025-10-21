import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/cart_model.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../widgets/other_dialogs/dialog.dart';
import 'dialog/choose_deli_type_dialog.dart';
import 'dialog/choose_table_dialog.dart';
import 'dialog/select_promotion_dialog.dart';
import 'dialog/update_cart_item_dialog.dart';

const double _padding = 12.0;
const double _spacing = 8.0;

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
          if (model.status == ViewStatus.Loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (model.cart.productList == null ||
              model.cart.productList!.isEmpty) {
            return _buildEmptyCart();
          }

          return Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.onInverseSurface,
            ),
            child: Column(
              children: [
                _buildCartHeader(),
                Expanded(
                  child: _buildCartItemsList(model),
                ),
                _buildCartSummary(model),
                _buildCartActions(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Get.theme.colorScheme.outline,
          ),
          SizedBox(height: _spacing),
          Text(
            'Giỏ hàng trống',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _spacing),
          Text(
            'Thêm sản phẩm để bắt đầu',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartHeader() {
    return Container(
      padding: const EdgeInsets.all(_padding),
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
            Icons.shopping_bag,
            size: 28,
            color: Get.theme.colorScheme.primary,
          ),
          SizedBox(width: _spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Giỏ hàng',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _padding,
        vertical: _spacing,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Text(
              'Sản phẩm',
              style: Get.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'SL',
              style: Get.textTheme.labelLarge?.copyWith(
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
                style: Get.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList(CartViewModel model) {
    return Column(
      children: [
        _buildProductHeader(),
        Divider(
          color: Get.theme.colorScheme.outlineVariant,
          thickness: 1,
          height: 1,
        ),
        Expanded(
          child: ListView.separated(
            itemCount: model.cart.productList!.length,
            physics: ScrollPhysics(),
            separatorBuilder: (context, i) => Divider(
              color: Get.theme.colorScheme.outlineVariant,
              thickness: 0.5,
              height: 1,
            ),
            itemBuilder: (context, i) => _CartItemCard(
              item: model.cart.productList![i],
              index: i,
              onTap: () => Get.dialog(
                UpdateCartItemDialog(
                  cartItem: model.cart.productList![i],
                  idx: i,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartSummary(CartViewModel model) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
          bottom: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model.customer != null)
            Padding(
              padding: const EdgeInsets.only(bottom: _spacing),
              child: Container(
                padding: EdgeInsets.all(_spacing),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.customer?.fullName ?? '',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      model.customer?.phoneNumber ?? '',
                      style: Get.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          _buildSummaryRow(
            'Số lượng',
            model.countCartQuantity().toString(),
            isBold: true,
          ),
          _buildSummaryRow(
            'Tạm tính',
            formatPrice(model.cart.totalAmount ?? 0),
            isBold: true,
          ),
          if (model.cart.promotionList != null &&
              model.cart.promotionList!.isNotEmpty) ...[
            SizedBox(height: _spacing),
            Text(
              'Khuyến mãi',
              style: Get.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...List.generate(
              model.cart.promotionList!.length,
              (i) {
                final promo = model.cart.promotionList![i];
                final displayValue = promo.effectType == "GET_POINT"
                    ? "+${promo.discountAmount} Điểm"
                    : "-${formatPrice(promo.discountAmount!)}";
                return _buildSummaryRow(
                  "🎁 ${promo.name}",
                  displayValue,
                  isDiscount: true,
                );
              },
            ),
          ],
          if (model.cart.discountAmount != null &&
              model.cart.discountAmount! > 0) ...[
            SizedBox(height: _spacing),
            _buildSummaryRow(
              'Tổng giảm',
              formatPrice(model.cart.discountAmount ?? 0),
              isDiscount: true,
            ),
          ],
          Divider(
            color: Get.theme.colorScheme.outline,
            thickness: 1,
            height: _spacing * 2,
          ),
          _buildSummaryRow(
            'Tổng tiền',
            formatPrice(model.cart.finalAmount ?? 0),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                (isTotal ? Get.textTheme.titleMedium : Get.textTheme.bodyMedium)
                    ?.copyWith(
              fontWeight:
                  (isTotal || isBold) ? FontWeight.bold : FontWeight.normal,
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
              fontWeight:
                  (isTotal || isBold) ? FontWeight.bold : FontWeight.w600,
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

  Widget _buildCartActions(CartViewModel model) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: model.cart.notes,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: "Ghi chú đơn hàng",
              prefixIcon: Icon(Icons.note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) => model.setCartNote(value),
          ),
          SizedBox(height: _spacing),
          Row(
            children: [
              FilledButton.tonal(
                onPressed: () => chooseTableDialog(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _spacing,
                    vertical: _spacing,
                  ),
                  child: Text('STT: ${model.cart.customerNumber}'),
                ),
              ),
              SizedBox(width: _spacing),
              FilledButton.tonal(
                onPressed: () => chooseDeliTypeDialog(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _spacing,
                    vertical: _spacing,
                  ),
                  child: Text(
                    showOrderType(
                      model.cart.orderType ?? DeliType().eatIn.type,
                    ).label,
                  ),
                ),
              ),
              SizedBox(width: _spacing),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => selectPromotionDialog(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _spacing,
                      vertical: _spacing,
                    ),
                    child: Text('Khuyến mãi'),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: _spacing),
          Row(
            children: [
              SizedBox(
                width: 56,
                height: 56,
                child: IconButton.filled(
                  onPressed: () async {
                    var result = await showConfirmDialog(
                      title: 'Xác nhận',
                      content: 'Xóa toàn bộ giỏ hàng?',
                    );
                    if (result) model.clearCartData();
                  },
                  icon: Icon(Icons.delete_outline),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Get.theme.colorScheme.errorContainer,
                    ),
                    foregroundColor: WidgetStateProperty.all(
                      Get.theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
              SizedBox(width: _spacing),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () async {
                    if (model.countCartQuantity() == 0) {
                      showAlertDialog(
                        title: 'Thông báo',
                        content: 'Giỏ hàng trống',
                      );
                      return;
                    }
                    model.createOrder();
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('Tạo đơn hàng'),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final ProductList item;
  final int index;
  final VoidCallback onTap;

  const _CartItemCard({
    required this.item,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _padding,
            vertical: _spacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatPrice(item.sellingPrice ?? 0),
                          style: Get.textTheme.bodySmall?.copyWith(
                            color: Get.theme.colorScheme.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatPrice(item.finalAmount ?? 0),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                        if (item.discount != null && item.discount! > 0)
                          Text(
                            "-${formatPrice(item.discount ?? 0)}",
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Get.theme.colorScheme.error,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (item.extras != null && item.extras!.isNotEmpty) ...[
                SizedBox(height: _spacing),
                ...List.generate(
                  item.extras!.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Text(
                            '  🔹 ${item.extras![i].name}',
                            style: Get.textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              '${item.extras![i].quantity}',
                              style: Get.textTheme.bodySmall,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '+${formatPrice(item.extras![i].totalAmount ?? 0)}',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if ((item.attributes != null && item.attributes!.isNotEmpty) ||
                  (item.note != null && item.note!.isNotEmpty)) ...[
                SizedBox(height: _spacing),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 4,
                        children: [
                          if (item.attributes != null)
                            for (int i = 0; i < item.attributes!.length; i++)
                              if (item.attributes![i].value != null &&
                                  item.attributes![i].value!.isNotEmpty)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        Get.theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.attributes![i].value!,
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                          if (item.note != null && item.note!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '📝 ${item.note}',
                                style: Get.textTheme.bodySmall?.copyWith(
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

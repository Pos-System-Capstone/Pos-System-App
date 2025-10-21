import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/views/screens/home/payment/payment_dialogs/input_customer_monney_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../view_model/index.dart';
import 'bill_screen.dart';

const double _padding = 12.0;
const double _spacing = 12.0;

class PaymentScreen extends StatefulWidget {
  String orderId;
  PaymentScreen(this.orderId, {super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late OrderViewModel orderViewModel;

  @override
  void initState() {
    super.initState();
    orderViewModel = Get.find<OrderViewModel>();
    orderViewModel.getOrderByStore(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: orderViewModel,
      child: Container(
        decoration: BoxDecoration(
          color: Get.theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        width: Get.width * 0.9,
        height: Get.height * 0.8,
        child: Column(
          children: [
            Expanded(
              child: Get.context!.isPortrait
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.all(_padding),
                            child: _PaymentMethodSection(),
                          ),
                          Container(
                            padding: EdgeInsets.all(_padding),
                            child: BillScreen(),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: _PaymentMethodSection(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: BillScreen(),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodSection extends StatelessWidget {
  const _PaymentMethodSection();

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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              Expanded(
                child: model.listPayment.isEmpty
                    ? _buildEmptyState()
                    : _buildPaymentMethodGrid(model),
              ),
              _buildStatusSection(model),
              _buildActionButtons(model),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
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
      child: Text(
        "Phương thức thanh toán",
        style: Get.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.payment_outlined,
            size: 56,
            color: Get.theme.colorScheme.outlineVariant,
          ),
          SizedBox(height: _spacing),
          Text(
            "Thanh toán mặc định",
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Sử dụng phương thức thanh toán mặc định là tiền mặt",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.outlineVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodGrid(OrderViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
        children: model.listPayment
            .map(
              (paymentMethod) => _PaymentMethodCard(
                paymentMethod: paymentMethod,
                isSelected: model.selectedPaymentMethod == paymentMethod,
                isPaymentComplete:
                    model.paymentCheckingStatus == PaymentStatusEnum.PAID,
                onTap: () async {
                  if (model.paymentCheckingStatus == PaymentStatusEnum.PAID) {
                    return;
                  }
                  if (paymentMethod?.type == PaymentTypeEnums.CASH) {
                    num money = await inputMonneyDialog();
                    model.setCustomerMoney(money);
                  } else {
                    model.setCustomerMoney(0);
                  }
                  if (paymentMethod != null) {
                    model.selectPayment(paymentMethod);
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStatusSection(OrderViewModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _padding,
        vertical: _spacing,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            model.paymentCheckingStatus == PaymentStatusEnum.PAID
                ? Icons.check_circle
                : Icons.schedule,
            color: model.paymentCheckingStatus == PaymentStatusEnum.PAID
                ? Colors.green
                : Colors.orange,
            size: 24,
          ),
          SizedBox(width: _spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trạng thái thanh toán",
                  style: Get.textTheme.labelLarge?.copyWith(
                    color: Get.theme.colorScheme.outlineVariant,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  showPaymentStatusEnum(model.paymentCheckingStatus),
                  style: Get.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: model.paymentCheckingStatus == PaymentStatusEnum.PAID
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(OrderViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: () {
                if (model.selectedPaymentMethod == null) {
                  Get.snackbar(
                    "Lỗi",
                    "Vui lòng chọn phương thức thanh toán",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  model.makePayment(model.selectedPaymentMethod!);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  model.paymentCheckingStatus == PaymentStatusEnum.PAID
                      ? Colors.green
                      : Get.theme.colorScheme.primary,
                ),
              ),
              child: Text(
                model.paymentCheckingStatus == PaymentStatusEnum.PAID
                    ? "Hoàn thành (Đơn hàng đã thanh toán)"
                    : "Thanh toán",
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: _spacing),
          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () async {
                num money = await inputMonneyDialog();
                model.setCustomerMoney(money);
              },
              icon: Icon(Icons.input),
              label: Text("Nhập tiền khách đưa"),
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  BorderSide(
                    color: Get.theme.colorScheme.outline,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final dynamic paymentMethod;
  final bool isSelected;
  final bool isPaymentComplete;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.paymentMethod,
    required this.isSelected,
    required this.isPaymentComplete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isPaymentComplete ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? Get.theme.colorScheme.primaryContainer
                : Get.theme.colorScheme.surface,
            border: Border.all(
              color: isSelected
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.outlineVariant,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Opacity(
            opacity: isPaymentComplete ? 0.6 : 1.0,
            child: Padding(
              padding: const EdgeInsets.all(_padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      paymentMethod.picUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color:
                                Get.theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.payment),
                        );
                      },
                    ),
                  ),
                  Text(
                    paymentMethod.name,
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Get.theme.colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

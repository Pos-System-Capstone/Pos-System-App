import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:pos_apps/views/widgets/other_dialogs/dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../data/model/response/order_in_list.dart';
import '../../../enums/order_enum.dart';
import '../../../enums/view_status.dart';
import '../../../helper/responsive_helper.dart';
import '../home/payment/payment_dialogs/payment_dialog.dart';
import 'dialogs/order_info_dailog.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const double _filterButtonHeight = 40.0;
  static const double _filterSpacing = 8.0;
  static const double _filterPadding = 12.0;

  late OrderViewModel orderViewModel;
  late TextEditingController orderController;
  bool isToday = true;
  String? invoice;
  String? status;
  String? payment;
  String? type;
  bool isYesterday = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    orderViewModel = Get.find<OrderViewModel>();
    orderController = TextEditingController();
    orderViewModel.getListOrder(
        isToday: isToday, isYesterday: isYesterday, page: page);
  }

  @override
  void dispose() {
    orderController.dispose();
    super.dispose();
  }

  void _fetchOrder() {
    orderViewModel.getListOrder(
        isToday: isToday,
        isYesterday: isYesterday,
        page: page,
        orderStatus: status,
        paymentType: payment,
        invoiceId: invoice);
  }

  void _resetFilters() {
    setState(() {
      status = null;
      payment = null;
      invoice = null;
      orderController.clear();
      page = 1;
      isToday = true;
      isYesterday = false;
    });
    _fetchOrder();
    Get.snackbar('Thành công', 'Đã đặt lại bộ lọc',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        margin: EdgeInsets.all(8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModel(
        model: orderViewModel,
        child: ScopedModelDescendant<OrderViewModel>(
          builder: (context, child, model) {
            return RefreshIndicator(
              onRefresh: () async {
                _fetchOrder();
                await Future.delayed(Duration(milliseconds: 500));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    _buildFilterSection(model),
                    Expanded(
                      child: model.status == ViewStatus.Loading &&
                              model.listOrder.isEmpty
                          ? _buildLoadingState()
                          : model.listOrder.isEmpty
                              ? _buildEmptyState()
                              : _buildOrdersList(model),
                    ),
                    if (model.listOrder.isNotEmpty)
                      _buildPaginationSection(model),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilterSection(OrderViewModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Payment Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(_filterPadding),
              child: Row(
                children: [
                  _FilterButton(
                    label: "Hôm nay",
                    isActive: isToday,
                    onPressed: () {
                      setState(() {
                        isToday = true;
                        isYesterday = false;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: "Hôm qua",
                    isActive: isYesterday,
                    onPressed: () {
                      setState(() {
                        isToday = false;
                        isYesterday = true;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: "Tiền mặt",
                    isActive: payment == PaymentTypeEnums.CASH,
                    onPressed: () {
                      setState(() {
                        payment = payment == PaymentTypeEnums.CASH
                            ? null
                            : PaymentTypeEnums.CASH;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: "Ngân hàng",
                    isActive: payment == PaymentTypeEnums.BANKING,
                    onPressed: () {
                      setState(() {
                        payment = payment == PaymentTypeEnums.BANKING
                            ? null
                            : PaymentTypeEnums.BANKING;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: "MOMO",
                    isActive: payment == PaymentTypeEnums.MOMO,
                    onPressed: () {
                      setState(() {
                        payment = payment == PaymentTypeEnums.MOMO
                            ? null
                            : PaymentTypeEnums.MOMO;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: "POINTIFY",
                    isActive: payment == PaymentTypeEnums.POINTIFY,
                    onPressed: () {
                      setState(() {
                        payment = payment == PaymentTypeEnums.POINTIFY
                            ? null
                            : PaymentTypeEnums.POINTIFY;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                ],
              ),
            ),
          ),
          // Search and Action Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _filterPadding),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: _filterButtonHeight + 4,
                    child: TextField(
                      controller: orderController,
                      decoration: InputDecoration(
                        hintText: "Quét mã để tìm đơn hàng",
                        hintStyle: Get.textTheme.bodyMedium,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        filled: true,
                        isDense: true,
                        fillColor: Get.theme.colorScheme.surface,
                        prefixIcon: Icon(Icons.portrait_rounded),
                        suffixIcon: orderController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  orderController.clear();
                                  setState(() => invoice = null);
                                  _fetchOrder();
                                },
                                icon: Icon(Icons.clear),
                              )
                            : null,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Get.theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Get.theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                      ),
                      onChanged: (value) => setState(() {}),
                      onSubmitted: (value) {
                        if (orderController.text.isNotEmpty) {
                          setState(() => invoice = value);
                          _fetchOrder();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: _filterSpacing),
                SizedBox(
                  height: _filterButtonHeight,
                  child: IconButton.filled(
                    onPressed: () {
                      if (orderController.text.isNotEmpty) {
                        setState(() => invoice = orderController.text);
                        _fetchOrder();
                      }
                    },
                    icon: Icon(Icons.search),
                    tooltip: "Tìm kiếm",
                  ),
                ),
                SizedBox(width: _filterSpacing),
                SizedBox(
                  height: _filterButtonHeight,
                  child: IconButton(
                    onPressed: _resetFilters,
                    icon: Icon(Icons.replay_outlined),
                    tooltip: "Đặt lại",
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
          ),
          SizedBox(height: _filterPadding),
          // Order Status Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: _filterPadding),
              child: Row(
                children: [
                  Text(
                    "Trạng thái:",
                    style: Get.textTheme.labelLarge,
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: showOrderStatus(OrderStatusEnum.NEW),
                    isActive: status == OrderStatusEnum.NEW,
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        status = status == OrderStatusEnum.NEW
                            ? null
                            : OrderStatusEnum.NEW;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: showOrderStatus(OrderStatusEnum.PENDING),
                    isActive: status == OrderStatusEnum.PENDING,
                    color: Colors.orange,
                    onPressed: () {
                      setState(() {
                        status = status == OrderStatusEnum.PENDING
                            ? null
                            : OrderStatusEnum.PENDING;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                  SizedBox(width: _filterSpacing),
                  _FilterButton(
                    label: showOrderStatus(OrderStatusEnum.PAID),
                    isActive: status == OrderStatusEnum.PAID,
                    color: Colors.teal,
                    onPressed: () {
                      setState(() {
                        status = status == OrderStatusEnum.PAID
                            ? null
                            : OrderStatusEnum.PAID;
                        page = 1;
                      });
                      _fetchOrder();
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: _filterPadding),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    final gridCrossAxisCount = ResponsiveHelper.isDesktop()
        ? 3
        : ResponsiveHelper.isTab() || ResponsiveHelper.isSmallTab()
            ? 2
            : 1;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3,
        crossAxisCount: gridCrossAxisCount,
        children: List.generate(6, (index) {
          return _OrderCardSkeleton();
        }),
      ),
    );
  }

  Widget _buildOrdersList(OrderViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3,
        crossAxisCount: ResponsiveHelper.isDesktop()
            ? 3
            : ResponsiveHelper.isTab() || ResponsiveHelper.isSmallTab()
                ? 2
                : 1,
        children: [
          for (int i = 0; i < model.listOrder.length; i++)
            _OrderCard(
              order: model.listOrder[i],
              model: model,
              onTap: () => _handleOrderTap(model, model.listOrder[i]),
            )
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: Get.theme.colorScheme.outline,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Không có đơn hàng",
            style: Get.textTheme.titleLarge?.copyWith(
              color: Get.theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Thử thay đổi bộ lọc hoặc tìm kiếm",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.outlineVariant,
            ),
          ),
          SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _resetFilters,
            icon: Icon(Icons.refresh),
            label: Text("Đặt lại bộ lọc"),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationSection(OrderViewModel model) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.all(_filterPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Trang: ",
              style: Get.textTheme.labelLarge,
            ),
            SizedBox(width: _filterSpacing),
            for (var i = 1; i < 7; i++)
              Padding(
                padding: const EdgeInsets.only(right: _filterSpacing),
                child: _PaginationButton(
                  page: i,
                  isActive: page == i,
                  onPressed: () {
                    setState(() => page = i);
                    _fetchOrder();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleOrderTap(OrderViewModel model, OrderInList order) {
    if (order.status == OrderStatusEnum.PAID ||
        order.status == OrderStatusEnum.CANCELED) {
      orderInfoDialog(order.id ?? "");
    } else if (order.status == OrderStatusEnum.NEW) {
      showConfirmDialog(
        title: "Có đơn hàng chờ xác nhận",
        content:
            "Để xác nhận đơn hàng vui lòng bấm vào nút nhận đơn \n Để huỷ đơn vui lòng bấm nút huỷ",
        confirmText: "Nhận đơn",
        cancelText: "Huỷ đơn",
      ).then((value) {
        if (value) {
          model.confirmOrder(OrderStatusEnum.PENDING, order.id ?? '');
        } else {
          model.confirmOrder(OrderStatusEnum.CANCELED, order.id ?? '');
        }
      });
    } else {
      showPaymentBotomSheet(order.id!);
    }
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final Color? color;

  const _FilterButton({
    required this.label,
    required this.isActive,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive
                ? (color ?? Get.theme.colorScheme.primary).withOpacity(0.2)
                : Get.theme.colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: isActive
                  ? (color ?? Get.theme.colorScheme.primary)
                  : Get.theme.colorScheme.outline,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: Get.textTheme.labelLarge?.copyWith(
              color: isActive
                  ? (color ?? Get.theme.colorScheme.primary)
                  : Get.theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  final int page;
  final bool isActive;
  final VoidCallback onPressed;

  const _PaginationButton({
    required this.page,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: OutlinedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isActive
                ? Get.theme.colorScheme.primary
                : Get.theme.colorScheme.surface,
          ),
          foregroundColor: WidgetStateProperty.all(
            isActive
                ? Get.theme.colorScheme.onPrimary
                : Get.theme.colorScheme.onSurface,
          ),
          side: WidgetStateProperty.all(
            BorderSide(
              color: isActive
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.outline,
              width: isActive ? 2 : 1,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(page.toString()),
      ),
    );
  }
}

class _OrderCard extends StatefulWidget {
  final OrderInList order;
  final OrderViewModel model;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.model,
    required this.onTap,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.order.status);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.surfaceContainerHighest,
                border: Border.all(
                  color: Get.theme.colorScheme.outline,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.order.invoiceId.toString(),
                          style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          border: Border.all(color: statusColor, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          showOrderStatus(widget.order.status ?? ''),
                          style: Get.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          formatTime(widget.order.endDate ??
                              DateTime.now().toString()),
                          style: Get.textTheme.bodySmall,
                        ),
                      ),
                      Text(
                        formatPrice(widget.order.finalAmount ?? 0),
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "KH: ${widget.order.customerName ?? 'Khách'} | ${widget.order.phone?.replaceFirst("+84", "0") ?? ""}",
                    style: Get.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == OrderStatusEnum.NEW) return Colors.grey;
    if (status == OrderStatusEnum.PENDING) return Colors.orange;
    if (status == OrderStatusEnum.PAID) return Colors.teal;
    return Colors.red;
  }
}

class _OrderCardSkeleton extends StatefulWidget {
  const _OrderCardSkeleton();

  @override
  State<_OrderCardSkeleton> createState() => _OrderCardSkeletonState();
}

class _OrderCardSkeletonState extends State<_OrderCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Get.theme.colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: Get.theme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerSkeleton(
                width: 100,
                height: 16,
                controller: _shimmerController,
              ),
              _ShimmerSkeleton(
                width: 60,
                height: 20,
                controller: _shimmerController,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ShimmerSkeleton(
                width: 80,
                height: 14,
                controller: _shimmerController,
              ),
              _ShimmerSkeleton(
                width: 70,
                height: 16,
                controller: _shimmerController,
              ),
            ],
          ),
          _ShimmerSkeleton(
            width: double.infinity,
            height: 12,
            controller: _shimmerController,
          ),
        ],
      ),
    );
  }
}

class _ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final AnimationController controller;

  const _ShimmerSkeleton({
    required this.width,
    required this.height,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: LinearGradient(
              begin: Alignment(-1 - controller.value * 2, 0),
              end: Alignment(1 + controller.value * 2, 0),
              colors: [
                Get.theme.colorScheme.surfaceContainerHighest,
                Get.theme.colorScheme.surfaceContainer,
                Get.theme.colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
        );
      },
    );
  }
}

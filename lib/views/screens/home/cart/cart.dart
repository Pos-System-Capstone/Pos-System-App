import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/enums/view_status.dart';
import 'package:pos_apps/helper/responsive_helper.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/views/screens/home/cart/dialog/choose_table_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../view_model/order_view_model.dart';
import 'cart_screen.dart';
import 'order_product.dart';
import 'product_cart.dart';

const double _padding = 12.0;
const double _spacing = 8.0;

class AddToCartScreen extends StatefulWidget {
  const AddToCartScreen({super.key});

  @override
  State<AddToCartScreen> createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(chooseTableDialog);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<OrderViewModel>(),
      child: ScopedModelDescendant<OrderViewModel>(
        builder: (context, child, model) {
          return Column(
            children: [
              Expanded(
                child: context.isPortrait
                    ? OrderProduct()
                    : Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OrderProduct(),
                          ),
                          Expanded(
                            flex: 1,
                            child: CartScreen(),
                          ),
                        ],
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCategoryScreen extends StatefulWidget {
  const _ProductCategoryScreen();

  @override
  State<_ProductCategoryScreen> createState() => _ProductCategoryScreenState();
}

class _ProductCategoryScreenState extends State<_ProductCategoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 0,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: Get.find<MenuViewModel>(),
      child: ScopedModelDescendant<MenuViewModel>(
        builder: (context, child, model) {
          if (model.status == ViewStatus.Loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (model.categories == null || model.categories!.isEmpty) {
            return _buildEmptyState();
          }

          // Update tab controller length
          if (_tabController.length != model.categories!.length) {
            _tabController = TabController(
              length: model.categories!.length,
              vsync: this,
            );
          }

          return Column(
            children: [
              _buildCategoryHeader(model),
              _buildCategoryTabs(model),
              Expanded(
                child: _buildProductGrid(model),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: Get.theme.colorScheme.outline,
          ),
          SizedBox(height: _spacing),
          Text(
            'Không có sản phẩm',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(MenuViewModel model) {
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
            Icons.dashboard,
            size: 28,
            color: Get.theme.colorScheme.primary,
          ),
          SizedBox(width: _spacing),
          Text(
            'Danh mục sản phẩm',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: _padding,
              vertical: _spacing,
            ),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${model.productsFilter?.length ?? 0} sản phẩm',
              style: Get.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(MenuViewModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Get.theme.colorScheme.primary,
        indicatorWeight: 3,
        labelStyle: Get.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: Get.textTheme.labelMedium,
        tabs: List.generate(
          model.categories!.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _padding,
              vertical: _spacing,
            ),
            child: Tab(
              child: Text(model.categories![index].name ?? ''),
            ),
          ),
        ),
        onTap: (value) {
          model.handleChangeFilterProductByCategory(
            model.categories![value].id,
          );
        },
      ),
    );
  }

  Widget _buildProductGrid(MenuViewModel model) {
    if (model.productsFilter == null || model.productsFilter!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: Get.theme.colorScheme.outline,
            ),
            SizedBox(height: _spacing),
            Text(
              'Không có sản phẩm trong danh mục',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Get.theme.colorScheme.outlineVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: GridView.count(
        scrollDirection: Axis.vertical,
        mainAxisSpacing: _spacing,
        crossAxisSpacing: _spacing,
        childAspectRatio: 3,
        crossAxisCount: ResponsiveHelper.isDesktop()
            ? 3
            : ResponsiveHelper.isTab() || ResponsiveHelper.isSmallTab()
                ? 2
                : 1,
        children: List.generate(
          model.productsFilter!.length,
          (i) => productCard(
            model.productsFilter![i],
            model.productsFilter![i].type == ProductTypeEnum.PARENT
                ? model.getChildProductByParentProduct(
                    model.productsFilter![i].id,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

// ...existing code... (Widget orderProduct and other widgets remain the same if called elsewhere)

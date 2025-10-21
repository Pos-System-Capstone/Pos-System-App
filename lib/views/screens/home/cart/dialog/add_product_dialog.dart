import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../data/model/cart_model.dart';
import '../../../../../data/model/index.dart';

class ProductDialog extends StatefulWidget {
  final Product product;
  const ProductDialog({required this.product, super.key});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  static const double _sectionPadding = 16.0;
  static const double _itemPadding = 8.0;
  static const double _sectionSpacing = 12.0;

  late MenuViewModel menuViewModel;
  late ProductViewModel productViewModel;
  late List<Product> childProducts;
  late List<Category> extraCategory;
  String? selectedSize;
  late List<Variants> listAttribute;
  late List<Attributes> selectedAttributes;

  @override
  void initState() {
    super.initState();
    menuViewModel = Get.find<MenuViewModel>();
    productViewModel = ProductViewModel();

    productViewModel.addProductToCartItem(widget.product);
    extraCategory = menuViewModel
            .getExtraCategoryByNormalProduct(widget.product.menuProductId) ??
        [];

    _initializeProductType();
    _initializeAttributes();
  }

  void _initializeProductType() {
    if (widget.product.type == ProductTypeEnum.PARENT) {
      childProducts =
          menuViewModel.getChildProductByParentProduct(widget.product.id) ?? [];
      if (childProducts.isNotEmpty) {
        selectedSize = childProducts[0].menuProductId;
        productViewModel.addProductToCartItem(childProducts[0]);
      }
    } else {
      childProducts = [];
    }
  }

  void _initializeAttributes() {
    listAttribute = widget.product.variants ?? [];
    selectedAttributes = listAttribute
        .map((attribute) => Attributes(name: attribute.name, value: null))
        .toList();
  }

  void setSelectedRadio(String val) {
    setState(() => selectedSize = val);
  }

  void setAttributes(int idx, String val) {
    setState(() => selectedAttributes[idx].value = val);
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = Get.context!.isPortrait;
    return Dialog(
      child: ScopedModel<ProductViewModel>(
        model: productViewModel,
        child: ScopedModelDescendant<ProductViewModel>(
          builder: (context, child, model) {
            return Container(
              width: isPortrait ? Get.size.width : Get.size.width * 0.6,
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (widget.product.type ==
                              ProductTypeEnum.PARENT) ...[
                            _buildProductSize(model),
                            _buildDivider(),
                          ],
                          if (extraCategory.isNotEmpty) ...[
                            _buildExtrasSection(model),
                            _buildDivider(),
                          ],
                          if (listAttribute.isNotEmpty)
                            _buildAttributesSection(model),
                        ],
                      ),
                    ),
                  ),
                  _buildFooterSection(model),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: _itemPadding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Get.theme.colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(_itemPadding),
            child: Icon(Icons.shopping_cart, size: 32),
          ),
          Expanded(
            child: Center(
              child: Text("Tuỳ chọn", style: Get.textTheme.titleLarge),
            ),
          ),
          IconButton(
            iconSize: 40,
            onPressed: () => Get.back(),
            icon: Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _sectionPadding),
      child: Divider(
        color: Get.theme.colorScheme.surfaceContainerHighest,
        thickness: 1,
        height: _sectionSpacing * 2,
      ),
    );
  }

  Widget _buildProductSize(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _sectionPadding,
        _sectionPadding,
        _sectionPadding,
        _sectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader("Kích cỡ", Icons.straighten),
          SizedBox(height: _sectionSpacing),
          ListView.builder(
            shrinkWrap: true,
            itemCount: childProducts.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) => _buildSizeOption(model, i),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(ProductViewModel model, int index) {
    final product = childProducts[index];
    final isSelected = selectedSize == product.menuProductId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            model.addProductToCartItem(product);
            setSelectedRadio(product.menuProductId);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(_itemPadding),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Get.theme.colorScheme.primary
                    : Get.theme.colorScheme.surfaceContainerHighest,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Get.theme.colorScheme.primaryContainer.withOpacity(0.3)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Get.textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  formatPrice(product.sellingPrice),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Get.theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExtrasSection(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        _sectionPadding,
        _sectionPadding,
        _sectionPadding,
        _sectionSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int categoryIdx = 0;
              categoryIdx < extraCategory.length;
              categoryIdx++)
            _buildExtraCategory(model, categoryIdx),
        ],
      ),
    );
  }

  Widget _buildExtraCategory(ProductViewModel model, int categoryIdx) {
    final category = extraCategory[categoryIdx];
    final extraProducts = menuViewModel.getProductsByCategory(category.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (categoryIdx > 0) SizedBox(height: _sectionSpacing),
        _SectionHeader(category.name ?? "", Icons.local_dining),
        SizedBox(height: _sectionSpacing),
        ...List.generate(
          extraProducts.length,
          (i) => _buildExtraItem(model, extraProducts[i]),
        ),
      ],
    );
  }

  Widget _buildExtraItem(ProductViewModel model, Product product) {
    final isSelected = model.isExtraExist(product.menuProductId ?? "");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => model.addOrRemoveExtra(product),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(_itemPadding),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected
                    ? Get.theme.colorScheme.primary
                    : Get.theme.colorScheme.surfaceContainerHighest,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: isSelected
                  ? Get.theme.colorScheme.primaryContainer.withOpacity(0.2)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: Get.textTheme.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "+ ${formatPrice(product.sellingPrice)}",
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Get.theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    Checkbox(
                      value: isSelected,
                      onChanged: (value) => model.addOrRemoveExtra(product),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesSection(ProductViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(_sectionPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader("Tùy chỉnh", Icons.tune),
          SizedBox(height: _sectionSpacing),
          ...List.generate(
            listAttribute.length,
            (i) => _buildAttributeGroup(i, model),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeGroup(int index, ProductViewModel model) {
    final attribute = listAttribute[index];
    final options = attribute.value?.split("_") ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(attribute.name, style: Get.textTheme.bodyLarge),
        SizedBox(height: _sectionSpacing),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options
              .map((option) => _buildAttributeOption(
                    option,
                    index,
                    model,
                  ))
              .toList(),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAttributeOption(
    String option,
    int attributeIndex,
    ProductViewModel model,
  ) {
    final isSelected = selectedAttributes[attributeIndex].value == option;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setAttributes(attributeIndex, option);
          model.setAttributes(selectedAttributes[attributeIndex]);
        },
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color:
                isSelected ? Get.theme.colorScheme.primary : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.surfaceContainerHighest,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            option,
            style: Get.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? Get.theme.colorScheme.onPrimary
                  : Get.theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(ProductViewModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Get.theme.colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.all(_sectionPadding),
      width: double.infinity,
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Ghi chú (tùy chọn)",
              prefixIcon: Icon(Icons.edit_note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: _itemPadding,
                horizontal: _itemPadding,
              ),
            ),
            onChanged: (value) => model.setNotes(value),
          ),
          SizedBox(height: _sectionPadding),
          _buildQuantityAndAddButton(model),
        ],
      ),
    );
  }

  Widget _buildQuantityAndAddButton(ProductViewModel model) {
    return Row(
      children: [
        _buildQuantityControl(model),
        SizedBox(width: _sectionPadding),
        Expanded(
          child: FilledButton(
            onPressed: () => model.addProductToCart(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Text(
                "Thêm ${formatPrice(model.productInCart.finalAmount!)}",
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Get.theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(ProductViewModel model) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Get.theme.colorScheme.surfaceContainerHighest,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            iconSize: 20,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: () {
              if (model.productInCart.quantity! > 1) {
                model.decreaseQuantity();
              }
            },
            icon: Icon(Icons.remove),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "${model.productInCart.quantity}",
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            iconSize: 20,
            padding: EdgeInsets.all(4),
            constraints: BoxConstraints(minWidth: 40, minHeight: 40),
            onPressed: () => model.increaseQuantity(),
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader(this.title, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Get.theme.colorScheme.primary,
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

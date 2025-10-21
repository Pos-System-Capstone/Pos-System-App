import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/cart_model.dart';
import 'package:pos_apps/enums/product_enum.dart';
import 'package:pos_apps/util/format.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/product_view_model.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../../../data/model/index.dart';

class UpdateCartItemDialog extends StatefulWidget {
  final ProductList cartItem;
  final int idx;
  const UpdateCartItemDialog(
      {required this.cartItem, required this.idx, super.key});

  @override
  State<UpdateCartItemDialog> createState() => _UpdateCartItemDialogState();
}

class _UpdateCartItemDialogState extends State<UpdateCartItemDialog> {
  static const double _sectionPadding = 16.0;
  static const double _itemPadding = 8.0;
  static const double _sectionSpacing = 12.0;

  late MenuViewModel menuViewModel;
  late ProductViewModel productViewModel;
  late List<Product> childProducts;
  late List<Category> extraCategory;
  String? selectedSize;
  late List<Variants> listVariants;
  late List<Attributes> selectedAttributes;
  Product? parentProduct;

  @override
  void initState() {
    super.initState();
    menuViewModel = Get.find<MenuViewModel>();
    productViewModel = ProductViewModel();

    productViewModel.getCartItemToUpdate(widget.cartItem);

    if (widget.cartItem.type == ProductTypeEnum.CHILD) {
      childProducts = menuViewModel.getChildProductByParentProduct(
          productViewModel.productInCart.parentProductId!)!;
      selectedSize = productViewModel.productInCart.productInMenuId;
      extraCategory = menuViewModel
          .getExtraCategoryByChildProduct(widget.cartItem.parentProductId!)!;
      parentProduct =
          menuViewModel.getProductById(widget.cartItem.parentProductId ?? "");
    } else {
      parentProduct = menuViewModel
          .getProductByMenuProductId(widget.cartItem.productInMenuId ?? "");
      extraCategory = menuViewModel
          .getExtraCategoryByNormalProduct(widget.cartItem.productInMenuId!)!;
      childProducts = [];
    }

    _initializeAttributes();
  }

  void _initializeAttributes() {
    listVariants = parentProduct?.variants ?? [];
    selectedAttributes = listVariants.map((attribute) {
      var existedAttr = widget.cartItem.attributes?.firstWhereOrNull(
        (element) => element.name == attribute.name,
      );
      return Attributes(
        name: attribute.name,
        value: existedAttr?.value,
      );
    }).toList();
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
                          if (widget.cartItem.type ==
                              ProductTypeEnum.CHILD) ...[
                            _buildProductSize(model),
                            _buildDivider(),
                          ],
                          if (extraCategory.isNotEmpty) ...[
                            _buildExtrasSection(model),
                            _buildDivider(),
                          ],
                          if (listVariants.isNotEmpty)
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
                  child: Text(
                    product.name,
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
            listVariants.length,
            (i) => _buildAttributeGroup(i, model),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeGroup(int index, ProductViewModel model) {
    final attribute = listVariants[index];
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
      margin: EdgeInsets.all(4),
      width: double.infinity,
      child: Column(
        children: [
          TextFormField(
            initialValue: model.productInCart.note,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Ghi chú",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) => model.setNotes(value),
          ),
          SizedBox(height: 4),
          _buildQuantityAndActionButtons(model),
        ],
      ),
    );
  }

  Widget _buildQuantityAndActionButtons(ProductViewModel model) {
    final isDeleteMode = model.productInCart.quantity == 0;

    return Row(
      children: [
        _buildQuantityControl(model),
        Expanded(
          child: isDeleteMode
              ? FilledButton(
                  onPressed: () {
                    model.deleteCartItemInCart(widget.idx);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                    child: Text(
                      "Xóa",
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                )
              : FilledButton(
                  onPressed: () {
                    model.updateCartItemInCart(widget.idx);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 16, 4, 16),
                    child: Text(
                      "Cập nhật ${formatPrice(model.productInCart.finalAmount!)}",
                      style: Get.textTheme.titleMedium?.copyWith(
                        color: Get.theme.colorScheme.surface,
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(ProductViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            if (model.productInCart.quantity! > 0) {
              model.decreaseQuantity();
              setState(() {});
            }
          },
          icon: Icon(Icons.remove, size: 48),
        ),
        Text(
          "${model.productInCart.quantity}",
          style: Get.textTheme.titleLarge,
        ),
        IconButton(
          onPressed: () {
            model.increaseQuantity();
            setState(() {});
          },
          icon: Icon(Icons.add, size: 48),
        ),
      ],
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

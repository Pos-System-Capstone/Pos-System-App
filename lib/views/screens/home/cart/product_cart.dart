import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/model/index.dart';
import '../../../../enums/product_enum.dart';
import '../../../../util/format.dart';
import 'dialog/add_product_dialog.dart';

const double _padding = 8.0;
const double _spacing = 4.0;
const String _placeholderImage =
    "https://firebasestorage.googleapis.com/v0/b/pos-system-47f93.appspot.com/o/files%2Fdownload.png?alt=media&token=d3d049e8-536e-4939-bb93-2704647445b4";

Widget productCard(Product product, List<Product>? childProducts) {
  if (childProducts == null && product.type == ProductTypeEnum.PARENT) {
    return _buildEmptyProductCard();
  }

  return _ProductCard(
    product: product,
    childProducts: childProducts,
  );
}

Widget _buildEmptyProductCard() {
  return Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: Get.theme.colorScheme.outlineVariant,
        width: 1,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_outlined,
            size: 32,
            color: Get.theme.colorScheme.outline,
          ),
          SizedBox(height: _spacing),
          Text(
            "Không có sản phẩm con",
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Get.theme.colorScheme.outlineVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProductCard extends StatefulWidget {
  final Product product;
  final List<Product>? childProducts;

  const _ProductCard({
    required this.product,
    required this.childProducts,
  });

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isImageLoading = true;
  bool _imageError = false;

  @override
  Widget build(BuildContext context) {
    final isParentProduct = widget.product.type == ProductTypeEnum.PARENT;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.dialog(ProductDialog(product: widget.product)),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // Product Image
                Expanded(
                  flex: 1,
                  child: _buildProductImage(),
                ),
                // Product Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(_padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.product.name,
                                style: Get.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (isParentProduct) ...[
                                SizedBox(height: _spacing),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Get
                                        .theme.colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Có ${widget.childProducts?.length ?? 0} loại",
                                    style: Get.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Price
                        if (!isParentProduct) ...[
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: _padding,
                              vertical: _spacing,
                            ),
                            decoration: BoxDecoration(
                              color: Get.theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              formatPrice(widget.product.sellingPrice),
                              style: Get.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.all(_padding),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.product.picUrl ?? _placeholderImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 32,
                      color: Get.theme.colorScheme.outline,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget extraCart(Product extra) {
  return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(_padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Extra Product Info
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          extra.name,
                          style: Get.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: _spacing),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          formatPrice(extra.sellingPrice),
                          style: Get.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Quantity Controls
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(top: _padding),
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
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  debugPrint("remove");
                                },
                                icon: Icon(Icons.remove, size: 18),
                                tooltip: "Giảm số lượng",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "0",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                onPressed: () {
                                  debugPrint("add");
                                },
                                icon: Icon(Icons.add, size: 18),
                                tooltip: "Tăng số lượng",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}

class Product {
  String? id;
  String? menuProductId;
  String? code;
  String? name;
  num? sellingPrice;
  String? picUrl;
  String? status;
  num? historicalPrice;
  num? discountPrice;
  String? description;
  int? displayOrder;
  String? size;
  String? type;
  String? parentProductId;
  String? brandId;
  String? categoryId;
  List<String>? collectionIds;
  List<String>? extraCategoryIds;

  Product(
      {this.id,
      this.menuProductId,
      this.code,
      this.name,
      this.sellingPrice,
      this.picUrl,
      this.status,
      this.historicalPrice,
      this.discountPrice,
      this.description,
      this.displayOrder,
      this.size,
      this.type,
      this.parentProductId,
      this.brandId,
      this.categoryId,
      this.collectionIds,
      this.extraCategoryIds});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    // sellingPrice = json['sellingPrice'];
    sellingPrice = json['sellingPrice'];
    picUrl = json['picUrl'];
    status = json['status'];
    historicalPrice = json['historicalPrice'];
    discountPrice = json['discountPrice'];
    description = json['description'];
    displayOrder = json['displayOrder'];
    size = json['size'];
    type = json['type'];
    parentProductId = json['parentProductId'];
    brandId = json['brandId'];
    categoryId = json['categoryId'];
    collectionIds = json['collectionIds'].cast<String>();
    extraCategoryIds = json['extraCategoryIds'].cast<String>();
    menuProductId = json['menuProductId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['sellingPrice'] = sellingPrice;
    data['picUrl'] = picUrl;
    data['status'] = status;
    data['historicalPrice'] = historicalPrice;
    data['discountPrice'] = discountPrice;
    data['description'] = description;
    data['displayOrder'] = displayOrder;
    data['size'] = size;
    data['type'] = type;
    data['parentProductId'] = parentProductId;
    data['brandId'] = brandId;
    data['categoryId'] = categoryId;
    data['collectionIds'] = collectionIds;
    data['extraCategoryIds'] = extraCategoryIds;
    data['menuProductId'] = menuProductId;
    return data;
  }
}

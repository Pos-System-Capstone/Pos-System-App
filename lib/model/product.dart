class Product {
  String? id;
  String? code;
  String? name;
  int? sellingPrice;
  String? picUrl;
  String? status;
  int? historicalPrice;
  int? discountPrice;
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['sellingPrice'] = this.sellingPrice;
    data['picUrl'] = this.picUrl;
    data['status'] = this.status;
    data['historicalPrice'] = this.historicalPrice;
    data['discountPrice'] = this.discountPrice;
    data['description'] = this.description;
    data['displayOrder'] = this.displayOrder;
    data['size'] = this.size;
    data['type'] = this.type;
    data['parentProductId'] = this.parentProductId;
    data['brandId'] = this.brandId;
    data['categoryId'] = this.categoryId;
    data['collectionIds'] = this.collectionIds;
    data['extraCategoryIds'] = this.extraCategoryIds;
    return data;
  }
}

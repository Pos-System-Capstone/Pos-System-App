class Product {
  late String id;
  late String code;
  late String name;
  late num sellingPrice;
  String? picUrl;
  String? status;
  num? historicalPrice;
  num? discountPrice;
  String? description;
  num? displayOrder;
  String? size;
  late String type;
  String? parentProductId;
  late String categoryId;
  List<String>? collectionIds;
  List<String>? extraCategoryIds;
  List<Variants>? variants;
  late String menuProductId;

  Product(
      {required this.id,
      required this.code,
      required this.name,
      required this.sellingPrice,
      this.picUrl,
      this.status,
      this.historicalPrice,
      this.discountPrice,
      this.description,
      this.displayOrder,
      this.size,
      required this.type,
      this.parentProductId,
      required this.categoryId,
      this.collectionIds,
      this.extraCategoryIds,
      this.variants,
      required this.menuProductId});

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
    categoryId = json['categoryId'];
    collectionIds = json['collectionIds'].cast<String>();
    extraCategoryIds = json['extraCategoryIds'].cast<String>();
    if (json['variants'] != null) {
      variants = <Variants>[];
      json['variants'].forEach((v) {
        variants!.add(Variants.fromJson(v));
      });
    }
    menuProductId = json['menuProductId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['categoryId'] = categoryId;
    data['collectionIds'] = collectionIds;
    data['extraCategoryIds'] = extraCategoryIds;
    if (variants != null) {
      data['variants'] = variants!.map((v) => v.toJson()).toList();
    }
    data['menuProductId'] = menuProductId;
    return data;
  }
}

class Variants {
  String? id;
  late String name;
  String? value;
  int? displayOrder;

  Variants({this.id, required this.name, this.value, this.displayOrder});

  Variants.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    value = json['value'];
    displayOrder = json['displayOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['value'] = value;
    data['displayOrder'] = displayOrder;
    return data;
  }
}

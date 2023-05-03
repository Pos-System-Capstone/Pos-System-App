import 'index.dart';

class Menu {
  String? id;
  String? brandId;
  String? code;
  int? priority;
  bool? isBaseMenu;
  List<String>? dateFilter;
  String? startTime;
  String? endTime;
  List<Product>? products;
  List<Collection>? collections;
  List<Category>? categories;
  List<GroupProducts>? groupProducts;
  List<ProductsInGroup>? productsInGroup;

  Menu(
      {this.id,
      this.brandId,
      this.code,
      this.priority,
      this.isBaseMenu,
      this.dateFilter,
      this.startTime,
      this.endTime,
      this.products,
      this.collections,
      this.categories,
      this.groupProducts,
      this.productsInGroup});

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brandId = json['brandId'];
    code = json['code'];
    priority = json['priority'];
    isBaseMenu = json['isBaseMenu'];
    dateFilter = json['dateFilter'].cast<String>();
    startTime = json['startTime'];
    endTime = json['endTime'];
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
    if (json['collections'] != null) {
      collections = <Collection>[];
      json['collections'].forEach((v) {
        collections!.add(Collection.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Category>[];
      json['categories'].forEach((v) {
        categories!.add(Category.fromJson(v));
      });
    }
    if (json['groupProducts'] != null) {
      groupProducts = <GroupProducts>[];
      json['groupProducts'].forEach((v) {
        groupProducts!.add(GroupProducts.fromJson(v));
      });
    }
    if (json['productsInGroup'] != null) {
      productsInGroup = <ProductsInGroup>[];
      json['productsInGroup'].forEach((v) {
        productsInGroup!.add(ProductsInGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brandId'] = brandId;
    data['code'] = code;
    data['priority'] = priority;
    data['isBaseMenu'] = isBaseMenu;
    data['dateFilter'] = dateFilter;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    if (collections != null) {
      data['collections'] = collections!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (groupProducts != null) {
      data['groupProducts'] = groupProducts!.map((v) => v.toJson()).toList();
    }
    if (productsInGroup != null) {
      data['productsInGroup'] =
          productsInGroup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupProducts {
  String? id;
  String? comboProductId;
  String? name;
  String? combinationMode;
  int? priority;
  int? quantity;
  String? status;
  List<String>? productsInGroupIds;

  GroupProducts(
      {this.id,
      this.comboProductId,
      this.name,
      this.combinationMode,
      this.priority,
      this.quantity,
      this.status,
      this.productsInGroupIds});

  GroupProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comboProductId = json['comboProductId'];
    name = json['name'];
    combinationMode = json['combinationMode'];
    priority = json['priority'];
    quantity = json['quantity'];
    status = json['status'];
    productsInGroupIds = json['productsInGroupIds'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comboProductId'] = comboProductId;
    data['name'] = name;
    data['combinationMode'] = combinationMode;
    data['priority'] = priority;
    data['quantity'] = quantity;
    data['status'] = status;
    data['productsInGroupIds'] = productsInGroupIds;
    return data;
  }
}

class ProductsInGroup {
  String? id;
  String? groupProductId;
  String? productId;
  int? priority;
  int? additionalPrice;
  int? min;
  int? max;
  int? quantity;
  String? status;

  ProductsInGroup(
      {this.id,
      this.groupProductId,
      this.productId,
      this.priority,
      this.additionalPrice,
      this.min,
      this.max,
      this.quantity,
      this.status});

  ProductsInGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    groupProductId = json['groupProductId'];
    productId = json['productId'];
    priority = json['priority'];
    additionalPrice = json['additionalPrice'];
    min = json['min'];
    max = json['max'];
    quantity = json['quantity'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupProductId'] = groupProductId;
    data['productId'] = productId;
    data['priority'] = priority;
    data['additionalPrice'] = additionalPrice;
    data['min'] = min;
    data['max'] = max;
    data['quantity'] = quantity;
    data['status'] = status;
    return data;
  }
}

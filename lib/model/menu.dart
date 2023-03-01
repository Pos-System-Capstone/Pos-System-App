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
      this.categories});

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
    return data;
  }
}

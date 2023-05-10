class StoreEndDayReport {
  String? storeId;
  List<CategoryReports>? categoryReports;
  num? totalAmount;
  num? totalDiscount;
  num? vatAmount;
  num? finalAmount;
  num? productCosAmount;
  num? totalRevenue;
  num? inStoreAmount;
  num? deliAmount;
  num? takeAwayAmount;
  num? totalProduct;
  num? totalOrder;
  num? totalOrderInStore;
  num? totalOrderTakeAway;
  num? totalOrderDeli;
  num? averageBill;

  StoreEndDayReport(
      {this.storeId,
      this.categoryReports,
      this.totalAmount,
      this.totalDiscount,
      this.vatAmount,
      this.finalAmount,
      this.productCosAmount,
      this.totalRevenue,
      this.inStoreAmount,
      this.deliAmount,
      this.takeAwayAmount,
      this.totalProduct,
      this.totalOrder,
      this.totalOrderInStore,
      this.totalOrderTakeAway,
      this.totalOrderDeli,
      this.averageBill});

  StoreEndDayReport.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    if (json['categoryReports'] != null) {
      categoryReports = <CategoryReports>[];
      json['categoryReports'].forEach((v) {
        categoryReports!.add(CategoryReports.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    totalDiscount = json['totalDiscount'];
    vatAmount = json['vatAmount'];
    finalAmount = json['finalAmount'];
    productCosAmount = json['productCosAmount'];
    totalRevenue = json['totalRevenue'];
    inStoreAmount = json['inStoreAmount'];
    deliAmount = json['deliAmount'];
    takeAwayAmount = json['takeAwayAmount'];
    totalProduct = json['totalProduct'];
    totalOrder = json['totalOrder'];
    totalOrderInStore = json['totalOrderInStore'];
    totalOrderTakeAway = json['totalOrderTakeAway'];
    totalOrderDeli = json['totalOrderDeli'];
    averageBill = json['averageBill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    if (categoryReports != null) {
      data['categoryReports'] =
          categoryReports!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    data['totalDiscount'] = totalDiscount;
    data['vatAmount'] = vatAmount;
    data['finalAmount'] = finalAmount;
    data['productCosAmount'] = productCosAmount;
    data['totalRevenue'] = totalRevenue;
    data['inStoreAmount'] = inStoreAmount;
    data['deliAmount'] = deliAmount;
    data['takeAwayAmount'] = takeAwayAmount;
    data['totalProduct'] = totalProduct;
    data['totalOrder'] = totalOrder;
    data['totalOrderInStore'] = totalOrderInStore;
    data['totalOrderTakeAway'] = totalOrderTakeAway;
    data['totalOrderDeli'] = totalOrderDeli;
    data['averageBill'] = averageBill;
    return data;
  }
}

class CategoryReports {
  String? id;
  String? name;
  num? totalProduct;
  num? totalAmount;
  List<ProductReports>? productReports;

  CategoryReports(
      {this.id,
      this.name,
      this.totalProduct,
      this.totalAmount,
      this.productReports});

  CategoryReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    totalProduct = json['totalProduct'];
    totalAmount = json['totalAmount'];
    if (json['productReports'] != null) {
      productReports = <ProductReports>[];
      json['productReports'].forEach((v) {
        productReports!.add(ProductReports.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['totalProduct'] = totalProduct;
    data['totalAmount'] = totalAmount;
    if (productReports != null) {
      data['productReports'] = productReports!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductReports {
  String? id;
  String? name;
  num? quantity;
  num? totalAmount;

  ProductReports({this.id, this.name, this.quantity, this.totalAmount});

  ProductReports.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    data['totalAmount'] = totalAmount;
    return data;
  }
}

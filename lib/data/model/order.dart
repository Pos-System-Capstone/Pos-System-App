class OrderModel {
  String? orderType;
  List<ProductInOrder>? productsList;

  num? totalAmount;
  num? discountAmount;
  num? finalAmount;
  String? promotionId;

  OrderModel(
      {this.orderType,
      this.productsList,
      this.totalAmount,
      this.discountAmount,
      this.finalAmount,
      this.promotionId});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderType = json['orderType'];
    if (json['productsList'] != null) {
      productsList = <ProductInOrder>[];
      json['productsList'].forEach((v) {
        productsList!.add(ProductInOrder.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    discountAmount = json['discountAmount'];
    finalAmount = json['finalAmount'];
    promotionId = json['promotionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderType'] = orderType;
    if (productsList != null) {
      data['productsList'] = productsList!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    data['discountAmount'] = discountAmount;
    data['finalAmount'] = finalAmount;
    data['promotionId'] = promotionId;
    return data;
  }
}

class ProductInOrder {
  String? productInMenuId;
  int? quantity;
  num? sellingPrice;
  num? discount;
  String? note;
  List<ExtraInOrder>? extras;

  ProductInOrder(
      {this.productInMenuId,
      this.quantity,
      this.sellingPrice,
      this.discount,
      this.note,
      this.extras});

  ProductInOrder.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    quantity = json['quantity'];
    sellingPrice = json['sellingPrice'];
    discount = json['discount'];
    note = json['note'];
    if (json['extras'] != null) {
      extras = <ExtraInOrder>[];
      json['extras'].forEach((v) {
        extras!.add(ExtraInOrder.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['quantity'] = quantity;
    data['sellingPrice'] = sellingPrice;
    data['discount'] = discount;
    data['note'] = note;
    if (extras != null) {
      data['extras'] = extras!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExtraInOrder {
  String? productInMenuId;
  int? quantity;
  num? sellingPrice;
  num? discount;

  ExtraInOrder(
      {this.productInMenuId, this.quantity, this.sellingPrice, this.discount});

  ExtraInOrder.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    quantity = json['quantity'];
    sellingPrice = json['sellingPrice'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['quantity'] = quantity;
    data['sellingPrice'] = sellingPrice;
    data['discount'] = discount;
    return data;
  }
}

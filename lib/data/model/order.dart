class OrderModel {
  String? orderType;
  List<ProductInOrder>? productsList;

  num? totalAmount;
  num? discountAmount;
  num? finalAmount;
  List<PromotionInOrder>? promotionList;

  OrderModel(
      {this.orderType,
      this.productsList,
      this.totalAmount,
      this.discountAmount,
      this.finalAmount,
      this.promotionList});

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
    if (json['promotionList'] != null) {
      promotionList = <PromotionInOrder>[];
      json['promotionList'].forEach((v) {
        promotionList!.add(PromotionInOrder.fromJson(v));
      });
    }
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
    if (promotionList != null) {
      data['promotionList'] = promotionList!.map((v) => v.toJson()).toList();
    }
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

class PromotionInOrder {
  String? promotionId;
  String? promotionName;
  num? quantity;
  num? discountAmount;

  PromotionInOrder(
      {this.promotionId,
      this.promotionName,
      this.quantity,
      this.discountAmount});

  PromotionInOrder.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    quantity = json['quantity'];
    discountAmount = json['discountAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotionId'] = promotionId;
    data['quantity'] = quantity;
    data['discountAmount'] = discountAmount;
    return data;
  }
}

class CartModel {
  String? storeId;
  String? orderType;
  String? paymentType;
  List<ProductList>? productList;
  num? totalAmount;
  num? discountAmount;
  num? shippingFee;
  num? finalAmount;
  num? bonusPoint;
  String? promotionCode;
  String? voucherCode;
  List<PromotionList>? promotionList;
  String? customerId;
  String? customerName;
  String? deliveryAddress;
  String? message;
  num? customerNumber;
  String? notes;

  CartModel(
      {this.storeId,
      this.orderType,
      this.paymentType,
      this.productList,
      this.totalAmount,
      this.discountAmount,
      this.shippingFee,
      this.finalAmount,
      this.bonusPoint,
      this.promotionCode,
      this.voucherCode,
      this.promotionList,
      this.customerId,
      this.customerName,
      this.deliveryAddress,
      this.message,
      this.customerNumber,
      this.notes});

  CartModel.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    orderType = json['orderType'];
    paymentType = json['paymentType'];
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
    totalAmount = json['totalAmount'];
    discountAmount = json['discountAmount'];
    shippingFee = json['shippingFee'];
    finalAmount = json['finalAmount'];
    bonusPoint = json['bonusPoint'];
    promotionCode = json['promotionCode'];
    voucherCode = json['voucherCode'];
    if (json['promotionList'] != null) {
      promotionList = <PromotionList>[];
      json['promotionList'].forEach((v) {
        promotionList!.add(PromotionList.fromJson(v));
      });
    }
    customerId = json['customerId'];
    customerName = json['customerName'];
    deliveryAddress = json['deliveryAddress'];
    message = json['message'];
    customerNumber = json['customerNumber'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    data['orderType'] = orderType;
    data['paymentType'] = paymentType;
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    data['totalAmount'] = totalAmount;
    data['discountAmount'] = discountAmount;
    data['shippingFee'] = shippingFee;
    data['finalAmount'] = finalAmount;
    data['bonusPoint'] = bonusPoint;
    data['promotionCode'] = promotionCode;
    data['voucherCode'] = voucherCode;
    if (promotionList != null) {
      data['promotionList'] = promotionList!.map((v) => v.toJson()).toList();
    }
    data['customerId'] = customerId;
    data['customerName'] = customerName;
    data['deliveryAddress'] = deliveryAddress;
    data['message'] = message;
    data['customerNumber'] = customerNumber;
    data['notes'] = notes;
    return data;
  }
}

class ProductList {
  String? productInMenuId;
  String? parentProductId;
  String? name;
  String? type;
  num? quantity;
  num? sellingPrice;
  String? code;
  String? categoryCode;
  num? totalAmount;
  num? discount;
  num? finalAmount;
  String? promotionCodeApplied;
  String? note;
  List<Extras>? extras;
  List<Attributes>? attributes;

  ProductList(
      {this.productInMenuId,
      this.parentProductId,
      this.name,
      this.type,
      this.quantity,
      this.sellingPrice,
      this.code,
      this.categoryCode,
      this.totalAmount,
      this.discount,
      this.finalAmount,
      this.promotionCodeApplied,
      this.note,
      this.extras,
      this.attributes});

  ProductList.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    parentProductId = json['parentProductId'];
    name = json['name'];
    type = json['type'];
    quantity = json['quantity'];
    sellingPrice = json['sellingPrice'];
    code = json['code'];
    categoryCode = json['categoryCode'];
    totalAmount = json['totalAmount'];
    discount = json['discount'];
    finalAmount = json['finalAmount'];
    promotionCodeApplied = json['promotionCodeApplied'];
    note = json['note'];
    if (json['extras'] != null) {
      extras = <Extras>[];
      json['extras'].forEach((v) {
        extras!.add(Extras.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['parentProductId'] = parentProductId;
    data['name'] = name;
    data['type'] = type;
    data['quantity'] = quantity;
    data['sellingPrice'] = sellingPrice;
    data['code'] = code;
    data['categoryCode'] = categoryCode;
    data['totalAmount'] = totalAmount;
    data['discount'] = discount;
    data['finalAmount'] = finalAmount;
    data['promotionCodeApplied'] = promotionCodeApplied;
    data['note'] = note;
    if (extras != null) {
      data['extras'] = extras!.map((v) => v.toJson()).toList();
    }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Extras {
  String? productInMenuId;
  String? name;
  num? quantity;
  num? sellingPrice;
  num? totalAmount;

  Extras(
      {this.productInMenuId,
      this.name,
      this.quantity,
      this.sellingPrice,
      this.totalAmount});

  Extras.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    name = json['name'];
    quantity = json['quantity'];
    sellingPrice = json['sellingPrice'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['name'] = name;
    data['quantity'] = quantity;
    data['sellingPrice'] = sellingPrice;
    data['totalAmount'] = totalAmount;
    return data;
  }
}

class Attributes {
  String? name;
  String? value;

  Attributes({this.name, this.value});

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['value'] = value;
    return data;
  }
}

class PromotionList {
  String? promotionId;
  String? code;
  String? name;
  num? discountAmount;
  String? effectType;

  PromotionList(
      {this.promotionId,
      this.code,
      this.name,
      this.discountAmount,
      this.effectType});

  PromotionList.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    code = json['code'];
    name = json['name'];
    discountAmount = json['discountAmount'];
    effectType = json['effectType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotionId'] = promotionId;
    data['code'] = code;
    data['name'] = name;
    data['discountAmount'] = discountAmount;
    data['effectType'] = effectType;
    return data;
  }
}

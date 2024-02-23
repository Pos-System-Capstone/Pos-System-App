class OrderResponseModel {
  String? orderId;
  String? invoiceId;
  String? storeName;
  num? totalAmount;
  num? finalAmount;
  num? vat;
  num? vatAmount;
  num? discount;
  String? orderStatus;
  String? orderType;
  String? paymentType;
  String? checkInDate;
  num? customerNumber;
  List<PromotionList>? promotionList;
  List<ProductList>? productList;
  CustomerInfo? customerInfo;

  OrderResponseModel(
      {this.orderId,
      this.invoiceId,
      this.storeName,
      this.totalAmount,
      this.finalAmount,
      this.vat,
      this.vatAmount,
      this.discount,
      this.orderStatus,
      this.orderType,
      this.paymentType,
      this.checkInDate,
      this.customerNumber,
      this.promotionList,
      this.productList,
      this.customerInfo});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    invoiceId = json['invoiceId'];
    storeName = json['storeName'];
    totalAmount = json['totalAmount'];
    finalAmount = json['finalAmount'];
    vat = json['vat'];
    vatAmount = json['vatAmount'];
    discount = json['discount'];
    orderStatus = json['orderStatus'];
    orderType = json['orderType'];
    paymentType = json['paymentType'];
    checkInDate = json['checkInDate'];
    customerNumber = json['customerNumber'];
    if (json['promotionList'] != null) {
      promotionList = <PromotionList>[];
      json['promotionList'].forEach((v) {
        promotionList!.add(PromotionList.fromJson(v));
      });
    }
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
    customerInfo = json['customerInfo'] != null
        ? CustomerInfo.fromJson(json['customerInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['invoiceId'] = invoiceId;
    data['storeName'] = storeName;
    data['totalAmount'] = totalAmount;
    data['finalAmount'] = finalAmount;
    data['vat'] = vat;
    data['vatAmount'] = vatAmount;
    data['discount'] = discount;
    data['orderStatus'] = orderStatus;
    data['orderType'] = orderType;
    data['paymentType'] = paymentType;
    data['checkInDate'] = checkInDate;
    data['customerNumber'] = customerNumber;
    if (promotionList != null) {
      data['promotionList'] = promotionList!.map((v) => v.toJson()).toList();
    }
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    if (customerInfo != null) {
      data['customerInfo'] = customerInfo!.toJson();
    }
    return data;
  }
}

class PromotionList {
  String? promotionId;
  String? promotionName;
  num? discountAmount;
  num? quantity;
  String? effectType;

  PromotionList(
      {this.promotionId,
      this.promotionName,
      this.discountAmount,
      this.quantity,
      this.effectType});

  PromotionList.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    promotionName = json['promotionName'];
    discountAmount = json['discountAmount'];
    quantity = json['quantity'];
    effectType = json['effectType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotionId'] = promotionId;
    data['promotionName'] = promotionName;
    data['discountAmount'] = discountAmount;
    data['quantity'] = quantity;
    data['effectType'] = effectType;
    return data;
  }
}

class ProductList {
  String? productInMenuId;
  String? orderDetailId;
  num? sellingPrice;
  num? quantity;
  String? name;
  num? totalAmount;
  num? finalAmount;
  num? discount;
  String? note;
  List<Extras>? extras;

  ProductList(
      {this.productInMenuId,
      this.orderDetailId,
      this.sellingPrice,
      this.quantity,
      this.name,
      this.totalAmount,
      this.finalAmount,
      this.discount,
      this.note,
      this.extras});

  ProductList.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    orderDetailId = json['orderDetailId'];
    sellingPrice = json['sellingPrice'];
    quantity = json['quantity'];
    name = json['name'];
    totalAmount = json['totalAmount'];
    finalAmount = json['finalAmount'];
    discount = json['discount'];
    note = json['note'];
    if (json['extras'] != null) {
      extras = <Extras>[];
      json['extras'].forEach((v) {
        extras!.add(Extras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['orderDetailId'] = orderDetailId;
    data['sellingPrice'] = sellingPrice;
    data['quantity'] = quantity;
    data['name'] = name;
    data['totalAmount'] = totalAmount;
    data['finalAmount'] = finalAmount;
    data['discount'] = discount;
    data['note'] = note;
    if (extras != null) {
      data['extras'] = extras!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Extras {
  String? productInMenuId;
  num? sellingPrice;
  num? quantity;
  num? totalAmount;
  num? finalAmount;
  num? discount;
  String? name;

  Extras(
      {this.productInMenuId,
      this.sellingPrice,
      this.quantity,
      this.totalAmount,
      this.finalAmount,
      this.discount,
      this.name});

  Extras.fromJson(Map<String, dynamic> json) {
    productInMenuId = json['productInMenuId'];
    sellingPrice = json['sellingPrice'];
    quantity = json['quantity'];
    totalAmount = json['totalAmount'];
    finalAmount = json['finalAmount'];
    discount = json['discount'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productInMenuId'] = productInMenuId;
    data['sellingPrice'] = sellingPrice;
    data['quantity'] = quantity;
    data['totalAmount'] = totalAmount;
    data['finalAmount'] = finalAmount;
    data['discount'] = discount;
    data['name'] = name;
    return data;
  }
}

class CustomerInfo {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? customerType;
  String? deliTime;
  String? paymentStatus;
  String? deliStatus;

  CustomerInfo(
      {this.id,
      this.name,
      this.phone,
      this.address,
      this.customerType,
      this.deliTime,
      this.paymentStatus,
      this.deliStatus});

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    customerType = json['customerType'];
    deliTime = json['deliTime'];
    paymentStatus = json['paymentStatus'];
    deliStatus = json['deliStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['customerType'] = customerType;
    data['deliTime'] = deliTime;
    data['paymentStatus'] = paymentStatus;
    data['deliStatus'] = deliStatus;
    return data;
  }
}

class OrderResponseModel {
  String? orderId;
  String? invoiceId;
  num? totalAmount;
  num? finalAmount;
  num? vat;
  num? vatAmount;
  num? discount;
  String? orderStatus;
  String? orderType;
  String? paymentType;
  String? checkInDate;
  List<PromotionList>? promotionList;
  List<ProductList>? productList;
  CustomerInfo? customerInfo;

  OrderResponseModel(
      {this.orderId,
      this.invoiceId,
      this.totalAmount,
      this.finalAmount,
      this.vat,
      this.vatAmount,
      this.discount,
      this.orderStatus,
      this.orderType,
      this.paymentType,
      this.checkInDate,
      this.promotionList,
      this.productList,
      this.customerInfo});

  OrderResponseModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    invoiceId = json['invoiceId'];
    totalAmount = json['totalAmount'];
    finalAmount = json['finalAmount'];
    vat = json['vat'];
    vatAmount = json['vatAmount'];
    discount = json['discount'];
    orderStatus = json['orderStatus'];
    orderType = json['orderType'];
    paymentType = json['paymentType'];
    checkInDate = json['checkInDate'];
    if (json['promotionList'] != null) {
      promotionList = <PromotionList>[];
      json['promotionList'].forEach((v) {
        promotionList!.add(new PromotionList.fromJson(v));
      });
    }
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
    customerInfo = json['customerInfo'] != null
        ? new CustomerInfo.fromJson(json['customerInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['invoiceId'] = this.invoiceId;
    data['totalAmount'] = this.totalAmount;
    data['finalAmount'] = this.finalAmount;
    data['vat'] = this.vat;
    data['vatAmount'] = this.vatAmount;
    data['discount'] = this.discount;
    data['orderStatus'] = this.orderStatus;
    data['orderType'] = this.orderType;
    data['paymentType'] = this.paymentType;
    data['checkInDate'] = this.checkInDate;
    if (this.promotionList != null) {
      data['promotionList'] =
          this.promotionList!.map((v) => v.toJson()).toList();
    }
    if (this.productList != null) {
      data['productList'] = this.productList!.map((v) => v.toJson()).toList();
    }
    if (this.customerInfo != null) {
      data['customerInfo'] = this.customerInfo!.toJson();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionId'] = this.promotionId;
    data['promotionName'] = this.promotionName;
    data['discountAmount'] = this.discountAmount;
    data['quantity'] = this.quantity;
    data['effectType'] = this.effectType;
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
        extras!.add(new Extras.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productInMenuId'] = this.productInMenuId;
    data['orderDetailId'] = this.orderDetailId;
    data['sellingPrice'] = this.sellingPrice;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    data['totalAmount'] = this.totalAmount;
    data['finalAmount'] = this.finalAmount;
    data['discount'] = this.discount;
    data['note'] = this.note;
    if (this.extras != null) {
      data['extras'] = this.extras!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productInMenuId'] = this.productInMenuId;
    data['sellingPrice'] = this.sellingPrice;
    data['quantity'] = this.quantity;
    data['totalAmount'] = this.totalAmount;
    data['finalAmount'] = this.finalAmount;
    data['discount'] = this.discount;
    data['name'] = this.name;
    return data;
  }
}

class CustomerInfo {
  String? id;
  String? name;
  String? phone;
  String? address;
  String? customerType;
  String? deliStatus;

  CustomerInfo(
      {this.id,
      this.name,
      this.phone,
      this.address,
      this.customerType,
      this.deliStatus});

  CustomerInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    address = json['address'];
    customerType = json['customerType'];
    deliStatus = json['deliStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['customerType'] = this.customerType;
    data['deliStatus'] = this.deliStatus;
    return data;
  }
}

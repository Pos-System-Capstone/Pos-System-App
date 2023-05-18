class OrderResponseModel {
  String? orderId;
  String? invoiceId;
  num? totalAmount;
  num? finalAmount;
  num? vat;
  num? vatAmount;
  num? discount;
  num? discountProduct = 0;
  num? discountPromotion = 0;
  String? orderStatus;
  String? orderType;
  String? checkInDate;
  String? discountName;
  String? paymentType;
  List<ProductList>? productList;
  PaymentMethod? paymentMethod;

  OrderResponseModel({
    this.orderId,
    this.invoiceId,
    this.totalAmount,
    this.finalAmount,
    this.vat,
    this.vatAmount,
    this.discount,
    this.discountProduct,
    this.discountPromotion,
    this.orderStatus,
    this.orderType,
    this.checkInDate,
    this.discountName,
    this.paymentType,
    this.productList,
    this.paymentMethod,
  });

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
    discountName = json['discountName'];
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['invoiceId'] = invoiceId;
    data['totalAmount'] = totalAmount;
    data['finalAmount'] = finalAmount;
    data['vat'] = vat;
    data['vatAmount'] = vatAmount;
    data['discount'] = discount;
    data['orderStatus'] = orderStatus;
    data['orderType'] = orderType;
    data['paymentType'] = paymentType;
    data['checkInDate'] = checkInDate;
    data['discountName'] = discountName;
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductList {
  String? productInMenuId;
  String? orderDetailId;
  num? sellingPrice;
  int? quantity;
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
  int? quantity;
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

class PaymentMethod {
  String? paymentProviderId;
  String? paymentProviderName;
  String? picUrl;

  PaymentMethod(
      {this.paymentProviderId, this.paymentProviderName, this.picUrl});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    paymentProviderId = json['paymentProviderId'];
    paymentProviderName = json['paymentProviderName'];
    picUrl = json['picUrl'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentProviderId'] = paymentProviderId;
    data['paymentProviderName'] = paymentProviderName;
    data['picUrl'] = picUrl;
    return data;
  }
}

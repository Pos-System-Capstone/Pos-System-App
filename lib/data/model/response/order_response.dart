class OrderResponseModel {
  String? orderId;
  String? invoiceId;
  int? totalAmount;
  int? finalAmount;
  int? vat;
  int? vatAmount;
  int? discount;
  String? orderStatus;
  String? orderType;
  String? checkInDate;
  Payment? payment;
  List<ProductList>? productList;

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
      this.checkInDate,
      this.payment,
      this.productList});

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
    checkInDate = json['checkInDate'];
    payment =
        json['payment'] != null ? new Payment.fromJson(json['payment']) : null;
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(new ProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = orderId;
    data['invoiceId'] = invoiceId;
    data['totalAmount'] = totalAmount;
    data['finalAmount'] = finalAmount;
    data['vat'] = vat;
    data['vatAmount'] = vatAmount;
    data['discount'] = discount;
    data['orderStatus'] = orderStatus;
    data['orderType'] = orderType;
    data['checkInDate'] = checkInDate;
    if (payment != null) {
      data['payment'] = payment!.toJson();
    }
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payment {
  String? id;
  String? paymentTypeId;
  String? paymentType;
  String? picUrl;
  int? paidAmount;

  Payment(
      {this.id,
      this.paymentTypeId,
      this.paymentType,
      this.picUrl,
      this.paidAmount});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentTypeId = json['paymentTypeId'];
    paymentType = json['paymentType'];
    picUrl = json['picUrl'];
    paidAmount = json['paidAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['paymentTypeId'] = paymentTypeId;
    data['paymentType'] = paymentType;
    data['picUrl'] = picUrl;
    data['paidAmount'] = paidAmount;
    return data;
  }
}

class ProductList {
  String? productInMenuId;
  String? orderDetailId;
  int? sellingPrice;
  int? quantity;
  String? name;
  int? totalAmount;
  int? finalAmount;
  int? discount;
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
  int? sellingPrice;
  int? quantity;
  int? totalAmount;
  int? finalAmount;
  int? discount;
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

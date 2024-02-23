class OrderInList {
  String? id;
  String? invoiceId;
  String? staffName;
  String? startDate;
  String? endDate;
  num? finalAmount;
  String? orderType;
  String? status;
  String? paymentType;
  String? paymentStatus;
  String? customerName;
  String? phone;
  String? address;
  String? storeName;

  OrderInList(
      {this.id,
      this.invoiceId,
      this.staffName,
      this.startDate,
      this.endDate,
      this.finalAmount,
      this.orderType,
      this.status,
      this.paymentType,
      this.paymentStatus,
      this.customerName,
      this.phone,
      this.address,
      this.storeName});

  OrderInList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceId = json['invoiceId'];
    staffName = json['staffName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    finalAmount = json['finalAmount'];
    orderType = json['orderType'];
    status = json['status'];
    paymentType = json['paymentType'];
    paymentStatus = json['paymentStatus'];
    customerName = json['customerName'];
    phone = json['phone'];
    address = json['address'];
    storeName = json['storeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['invoiceId'] = invoiceId;
    data['staffName'] = staffName;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['finalAmount'] = finalAmount;
    data['orderType'] = orderType;
    data['status'] = status;
    data['paymentType'] = paymentType;
    data['paymentStatus'] = paymentStatus;
    data['customerName'] = customerName;
    data['phone'] = phone;
    data['address'] = address;
    data['storeName'] = storeName;
    return data;
  }
}

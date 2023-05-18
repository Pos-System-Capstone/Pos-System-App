class OrderInList {
  String? id;
  String? invoiceId;
  String? staffName;
  String? startDate;
  String? endDate;
  num? finalAmount;
  String? orderType;
  String? paymentType;
  String? status;

  OrderInList(
      {this.id,
      this.invoiceId,
      this.staffName,
      this.startDate,
      this.endDate,
      this.finalAmount,
      this.orderType,
      this.paymentType,
      this.status});

  OrderInList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceId = json['invoiceId'];
    staffName = json['staffName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    finalAmount = json['finalAmount'];
    orderType = json['orderType'];
    paymentType = json['paymentType'];
    status = json['status'];
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
    data['paymentType'] = paymentType;
    data['status'] = status;
    return data;
  }
}

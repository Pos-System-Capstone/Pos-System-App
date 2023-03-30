class OrderInList {
  String? id;
  String? invoiceId;
  String? staffName;
  String? startDate;
  String? endDate;
  num? finalAmount;
  String? orderType;
  String? status;

  OrderInList(
      {this.id,
      this.invoiceId,
      this.staffName,
      this.startDate,
      this.endDate,
      this.finalAmount,
      this.orderType,
      this.status});

  OrderInList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceId = json['invoiceId'];
    staffName = json['staffName'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    finalAmount = json['finalAmount'];
    orderType = json['orderType'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoiceId'] = this.invoiceId;
    data['staffName'] = this.staffName;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['finalAmount'] = this.finalAmount;
    data['orderType'] = this.orderType;
    data['status'] = this.status;
    return data;
  }
}

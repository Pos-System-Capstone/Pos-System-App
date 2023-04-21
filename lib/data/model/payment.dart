class PaymentModel {
  String? id;
  String? name;
  String? picUrl;
  bool? isDisplay;
  int? position;
  String? brandId;

  PaymentModel(
      {this.id,
      this.name,
      this.picUrl,
      this.isDisplay,
      this.position,
      this.brandId});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picUrl = json['picUrl'];
    isDisplay = json['isDisplay'];
    position = json['position'];
    brandId = json['brandId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['picUrl'] = picUrl;
    data['isDisplay'] = isDisplay;
    data['position'] = position;
    data['brandId'] = brandId;
    return data;
  }

  List<PaymentModel> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => PaymentModel.fromJson(map)).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paymentTypeId'] = paymentTypeId;
    data['paymentType'] = paymentType;
    data['picUrl'] = picUrl;
    data['paidAmount'] = paidAmount;
    return data;
  }
}

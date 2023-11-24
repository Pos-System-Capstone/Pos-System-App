class MakePaymentResponse {
  String? orderId;
  String? paymentType;
  String? status;
  String? message;

  MakePaymentResponse(
      {this.orderId, this.paymentType, this.status, this.message});

  MakePaymentResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    paymentType = json['paymentType'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['orderId'] = orderId;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

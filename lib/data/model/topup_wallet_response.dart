class TopUpWalletResponse {
  String? orderId;
  String? userId;
  String? paymentType;
  String? status;
  String? message;

  TopUpWalletResponse(
      {this.orderId, this.userId, this.paymentType, this.status, this.message});

  TopUpWalletResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    paymentType = json['paymentType'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = orderId;
    data['userId'] = userId;
    data['paymentType'] = paymentType;
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

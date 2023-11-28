class TopUpWalletRequest {
  String? storeId;
  String? userId;
  num? amount;
  String? paymentType;

  TopUpWalletRequest(
      {this.storeId, this.userId, this.amount, this.paymentType});

  TopUpWalletRequest.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    userId = json['userId'];
    amount = json['amount'];
    paymentType = json['paymentType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    data['userId'] = userId;
    data['amount'] = amount;
    data['paymentType'] = paymentType;
    return data;
  }
}

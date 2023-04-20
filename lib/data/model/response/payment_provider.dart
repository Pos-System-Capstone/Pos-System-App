class PaymentProvider {
  String? id;
  String? name;
  String? type;
  String? picUrl;

  PaymentProvider({this.id, this.name, this.type, this.picUrl});

  PaymentProvider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    picUrl = json['picUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['picUrl'] = picUrl;
    return data;
  }

  List<PaymentProvider> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => PaymentProvider.fromJson(map)).toList();
  }
}

class PaymentStatusResponse {
  String? id;
  String? message;
  PaymentStatusResponse({this.id, this.message});
  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      id: json['id'],
      message: json['transactionStatus'],
    );
  }
}

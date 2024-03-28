class PaymentProvider {
  late String type;
  late String name;
  late String picUrl;

  PaymentProvider(
      {required this.type, required this.name, required this.picUrl});

  PaymentProvider.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    picUrl = json['picUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type;
    data['name'] = name;
    data['picUrl'] = picUrl;
    return data;
  }
}

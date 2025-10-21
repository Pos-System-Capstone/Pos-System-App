class Account {
  late String storeId;
  late String storeCode;
  late String brandId;
  late String brandCode;
  late String accessToken;
  late String id;
  late String username;
  late String name;
  String? role;
  String? status;
  String? brandPicUrl;

  Account(
      {required this.storeId,
      required this.storeCode,
      required this.brandId,
      required this.brandCode,
      required this.accessToken,
      required this.id,
      required this.username,
      required this.name,
      this.role,
      this.status,
      this.brandPicUrl});

  Account.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    storeCode = json['storeCode'];
    brandId = json['brandId'];
    brandCode = json['brandCode'];
    accessToken = json['accessToken'];
    id = json['id'];
    username = json['username'];
    name = json['name'];
    role = json['role'];
    status = json['status'];
    brandPicUrl = json['brandPicUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    data['storeCode'] = storeCode;
    data['brandId'] = brandId;
    data['brandCode'] = brandCode;
    data['accessToken'] = accessToken;
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['role'] = role;
    data['status'] = status;
    data['brandPicUrl'] = brandPicUrl;
    return data;
  }
}

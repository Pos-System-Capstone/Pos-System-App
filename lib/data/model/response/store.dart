class StoreModel {
  String? phone;
  String? code;
  String? brandPicUrl;
  String? id;
  String? brandId;
  String? name;
  String? shortName;
  String? email;
  String? address;
  String? status;
  String? wifiName;
  String? wifiPassword;

  StoreModel(
      {this.phone,
      this.code,
      this.brandPicUrl,
      this.id,
      this.brandId,
      this.name,
      this.shortName,
      this.email,
      this.address,
      this.status,
      this.wifiName,
      this.wifiPassword});

  StoreModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    code = json['code'];
    brandPicUrl = json['brandPicUrl'];
    id = json['id'];
    brandId = json['brandId'];
    name = json['name'];
    shortName = json['shortName'];
    email = json['email'];
    address = json['address'];
    status = json['status'];
    wifiName = json['wifiName'];
    wifiPassword = json['wifiPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phone'] = phone;
    data['code'] = code;
    data['brandPicUrl'] = brandPicUrl;
    data['id'] = id;
    data['brandId'] = brandId;
    data['name'] = name;
    data['shortName'] = shortName;
    data['email'] = email;
    data['address'] = address;
    data['status'] = status;
    return data;
  }
}

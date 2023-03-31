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
      this.status});

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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['code'] = this.code;
    data['brandPicUrl'] = this.brandPicUrl;
    data['id'] = this.id;
    data['brandId'] = this.brandId;
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    data['email'] = this.email;
    data['address'] = this.address;
    data['status'] = this.status;
    return data;
  }
}

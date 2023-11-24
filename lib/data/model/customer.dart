class CustomerInfoModel {
  String? id;
  String? phoneNumber;
  String? fullName;
  String? gender;
  String? email;

  CustomerInfoModel(
      {this.id, this.phoneNumber, this.fullName, this.gender, this.email});

  CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    fullName = json['fullName'];
    gender = json['gender'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['phoneNumber'] = phoneNumber;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['email'] = email;
    return data;
  }
}

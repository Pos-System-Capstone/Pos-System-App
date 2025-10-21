class CustomerInfoModel {
  String? membershipId;
  String? phoneNumber;
  String? email;
  String? fullName;
  num? gender;
  String? memberLevelName;
  num? point;
  num? balance;

  CustomerInfoModel(
      {this.membershipId,
      this.phoneNumber,
      this.email,
      this.fullName,
      this.gender,
      this.memberLevelName,
      this.point,
      this.balance});

  CustomerInfoModel.fromJson(Map<String, dynamic> json) {
    membershipId = json['membershipId'];
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    fullName = json['fullName'];
    gender = json['gender'];
    memberLevelName = json['memberLevelName'];
    point = json['point'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['membershipId'] = membershipId;
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['fullName'] = fullName;
    data['gender'] = gender;
    data['memberLevelName'] = memberLevelName;
    data['point'] = point;
    data['balance'] = balance;
    return data;
  }
}

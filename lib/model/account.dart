class Account {
  final String accessToken;
  final String id;
  final String name;
  final String userName;
  final String userRole;
  final String status;
  String? picUrl;

  Account({
    required this.accessToken,
    required this.id,
    required this.name,
    required this.userName,
    required this.userRole,
    required this.status,
    this.picUrl,
  });

  @override
  String toString() {
    return 'AccountDTO(uid: $id, name: $name, userName: $userName, userRole: $userRole, status: $status, picUrl: $picUrl)';
  }

  factory Account.fromJson(dynamic json) => Account(
      accessToken: json['accessToken'],
      id: json["id"],
      name: json['name'],
      userName: json['username'] as String,
      userRole: json['role'],
      status: json['status'],
      picUrl: json['picUrl'] ?? "");

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken.toString(),
      "id": id.toString(),
      "name": name,
      "username": userName,
      "role": userRole,
      "status": status,
      "picUrl": picUrl ?? "",
    };
  }
}

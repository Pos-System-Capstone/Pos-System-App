class Collection {
  String? id;
  String? name;
  String? code;
  String? picUrl;
  String? description;

  Collection({this.id, this.name, this.code, this.picUrl, this.description});

  Collection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    picUrl = json['picUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['picUrl'] = picUrl;
    data['description'] = description;
    return data;
  }
}

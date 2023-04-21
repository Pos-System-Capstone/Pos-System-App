class Category {
  String? id;
  String? code;
  String? name;
  String? type;
  int? displayOrder;
  String? description;
  String? picUrl;

  Category(
      {this.id,
      this.code,
      this.name,
      this.type,
      this.displayOrder,
      this.description,
      this.picUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
    displayOrder = json['displayOrder'];
    description = json['description'];
    picUrl = json['picUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['type'] = type;
    data['displayOrder'] = displayOrder;
    data['description'] = description;
    data['picUrl'] = picUrl;
    return data;
  }
}

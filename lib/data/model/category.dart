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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['type'] = this.type;
    data['displayOrder'] = this.displayOrder;
    data['description'] = this.description;
    data['picUrl'] = this.picUrl;
    return data;
  }
}

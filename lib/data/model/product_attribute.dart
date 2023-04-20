class Attribute {
  late String name;
  late List<String> options;

  Attribute(this.name, this.options);

  Attribute.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    options = json['options'].cast<String>();
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['options'] = options;
    return data;
  }

  static List<Attribute> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => Attribute.fromJson(map)).toList();
  }
}

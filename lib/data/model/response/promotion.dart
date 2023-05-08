class Promotion {
  String? id;
  String? name;
  String? code;
  String? description;
  String? type;
  num? maxDiscount;
  num? minConditionAmount;
  num? discountAmount;
  num? discountPercent;
  String? status;

  Promotion(
      {this.id,
      this.name,
      this.code,
      this.description,
      this.type,
      this.maxDiscount,
      this.minConditionAmount,
      this.discountAmount,
      this.discountPercent,
      this.status});

  Promotion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    description = json['description'];
    type = json['type'];
    maxDiscount = json['maxDiscount'];
    minConditionAmount = json['minConditionAmount'];
    discountAmount = json['discountAmount'];
    discountPercent = json['discountPercent'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['description'] = description;
    data['type'] = type;
    data['maxDiscount'] = maxDiscount;
    data['minConditionAmount'] = minConditionAmount;
    data['discountAmount'] = discountAmount;
    data['discountPercent'] = discountPercent;
    data['status'] = status;
    return data;
  }
}

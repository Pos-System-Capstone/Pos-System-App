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
  String? startTime;
  String? endTime;
  bool? isAvailable;
  List<ListProductApply>? listProductApply;
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
      this.startTime,
      this.endTime,
      this.isAvailable,
      this.listProductApply,
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
    startTime = json['startTime'];
    endTime = json['endTime'];
    isAvailable = json['isAvailable'];
    if (json['listProductApply'] != null) {
      listProductApply = <ListProductApply>[];
      json['listProductApply'].forEach((v) {
        listProductApply!.add(new ListProductApply.fromJson(v));
      });
    }
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
    if (listProductApply != null) {
      data['listProductApply'] =
          listProductApply!.map((v) => v.toJson()).toList();
    }
    data['status'] = status;
    return data;
  }
}

class ListProductApply {
  String? productId;

  ListProductApply({this.productId});

  ListProductApply.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = productId;
    return data;
  }
}

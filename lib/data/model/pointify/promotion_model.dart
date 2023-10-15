class PromotionPointify {
  String? promotionId;
  String? promotionTierId;
  String? promotionName;
  String? promotionCode;
  String? description;
  int? forMembership;
  int? actionType;
  int? saleMode;
  String? imgUrl;
  int? promotionType;
  int? tierIndex;

  PromotionPointify(
      {this.promotionId,
      this.promotionTierId,
      this.promotionName,
      this.promotionCode,
      this.description,
      this.forMembership,
      this.actionType,
      this.saleMode,
      this.imgUrl,
      this.promotionType,
      this.tierIndex});

  PromotionPointify.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    promotionTierId = json['promotionTierId'];
    promotionName = json['promotionName'];
    promotionCode = json['promotionCode'];
    description = json['description'];
    forMembership = json['forMembership'];
    actionType = json['actionType'];
    saleMode = json['saleMode'];
    imgUrl = json['imgUrl'];
    promotionType = json['promotionType'];
    tierIndex = json['tierIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['promotionId'] = promotionId;
    data['promotionTierId'] = promotionTierId;
    data['promotionName'] = promotionName;
    data['promotionCode'] = promotionCode;
    data['description'] = description;
    data['forMembership'] = forMembership;
    data['actionType'] = actionType;
    data['saleMode'] = saleMode;
    data['imgUrl'] = imgUrl;
    data['promotionType'] = promotionType;
    data['tierIndex'] = tierIndex;
    return data;
  }

  List<PromotionPointify> fromList(dynamic jsonList) {
    var list = jsonList as List;
    return list.map((map) => PromotionPointify.fromJson(map)).toList();
  }
}

class SessionDetails {
  String? sessionId;
  String? startDateTime;
  String? endDateTime;
  String? name;
  int? numberOfOrders;
  num? totalAmount;
  num? totalPromotion;
  num? currentCashInVault;
  num? initCashInVault;
  num? profitAmount;
  num? totalDiscountAmount;

  SessionDetails(
      {this.sessionId,
      this.startDateTime,
      this.endDateTime,
      this.name,
      this.numberOfOrders,
      this.totalAmount,
      this.totalPromotion,
      this.currentCashInVault,
      this.initCashInVault,
      this.profitAmount,
      this.totalDiscountAmount});

  SessionDetails.fromJson(Map<String, dynamic> json) {
    sessionId = json['sessionId'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    name = json['name'];
    numberOfOrders = json['numberOfOrders'];
    totalAmount = json['totalAmount'];
    totalPromotion = json['totalPromotion'];
    currentCashInVault = json['currentCashInVault'];
    initCashInVault = json['initCashInVault'];
    profitAmount = json['profitAmount'];
    totalDiscountAmount = json['totalDiscountAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sessionId'] = sessionId;
    data['startDateTime'] = startDateTime;
    data['endDateTime'] = endDateTime;
    data['name'] = name;
    data['numberOfOrders'] = numberOfOrders;
    data['totalAmount'] = totalAmount;
    data['totalPromotion'] = totalPromotion;
    data['currentCashInVault'] = currentCashInVault;
    data['initCashInVault'] = initCashInVault;
    data['profitAmount'] = profitAmount;
    data['totalDiscountAmount'] = totalDiscountAmount;
    return data;
  }
}

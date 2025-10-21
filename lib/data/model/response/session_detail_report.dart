class SessionDetailReport {
  int? totalAmount;
  int? totalDiscount;
  int? finalAmount;
  int? totalOrder;
  int? totalCash;
  int? totalBanking;
  int? totalMomo;
  int? totalVisa;
  int? totalPointify;
  int? totalGrabFood;
  int? totalShopeeFood;
  int? totalBeFood;
  int? cashAmount;
  int? momoAmount;
  int? bankingAmount;
  int? visaAmount;
  int? pointifyAmount;
  int? grabFoodAmount;
  int? shopeeFoodAmount;
  int? beFoodAmount;

  SessionDetailReport(
      {this.totalAmount,
      this.totalDiscount,
      this.finalAmount,
      this.totalOrder,
      this.totalCash,
      this.totalBanking,
      this.totalMomo,
      this.totalVisa,
      this.totalPointify,
      this.totalGrabFood,
      this.totalShopeeFood,
      this.totalBeFood,
      this.cashAmount,
      this.momoAmount,
      this.bankingAmount,
      this.visaAmount,
      this.pointifyAmount,
      this.grabFoodAmount,
      this.shopeeFoodAmount,
      this.beFoodAmount});

  SessionDetailReport.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalDiscount = json['totalDiscount'];
    finalAmount = json['finalAmount'];
    totalOrder = json['totalOrder'];
    totalCash = json['totalCash'];
    totalBanking = json['totalBanking'];
    totalMomo = json['totalMomo'];
    totalVisa = json['totalVisa'];
    totalPointify = json['totalPointify'];
    totalGrabFood = json['totalGrabFood'];
    totalShopeeFood = json['totalShopeeFood'];
    totalBeFood = json['totalBeFood'];
    cashAmount = json['cashAmount'];
    momoAmount = json['momoAmount'];
    bankingAmount = json['bankingAmount'];
    visaAmount = json['visaAmount'];
    pointifyAmount = json['pointifyAmount'];
    grabFoodAmount = json['grabFoodAmount'];
    shopeeFoodAmount = json['shopeeFoodAmount'];
    beFoodAmount = json['beFoodAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAmount'] = totalAmount;
    data['totalDiscount'] = totalDiscount;
    data['finalAmount'] = finalAmount;
    data['totalOrder'] = totalOrder;
    data['totalCash'] = totalCash;
    data['totalBanking'] = totalBanking;
    data['totalMomo'] = totalMomo;
    data['totalVisa'] = totalVisa;
    data['totalPointify'] = totalPointify;
    data['totalGrabFood'] = totalGrabFood;
    data['totalShopeeFood'] = totalShopeeFood;
    data['totalBeFood'] = totalBeFood;
    data['cashAmount'] = cashAmount;
    data['momoAmount'] = momoAmount;
    data['bankingAmount'] = bankingAmount;
    data['visaAmount'] = visaAmount;
    data['pointifyAmount'] = pointifyAmount;
    data['grabFoodAmount'] = grabFoodAmount;
    data['shopeeFoodAmount'] = shopeeFoodAmount;
    data['beFoodAmount'] = beFoodAmount;
    return data;
  }
}

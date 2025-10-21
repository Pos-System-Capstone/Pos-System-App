class DayReport {
  num? totalAmount;
  num? totalProductDiscount;
  num? totalPromotionDiscount;
  num? totalDiscount;
  num? vatAmount;
  num? finalAmount;
  num? productCosAmount;
  num? totalRevenue;
  num? averageBill;
  num? totalProduct;
  num? totalPromotionUsed;
  num? totalOrder;
  num? totalOrderInStore;
  num? totalOrderTakeAway;
  num? totalOrderDeli;
  num? totalOrderTopUp;
  num? inStoreAmount;
  num? deliAmount;
  num? takeAwayAmount;
  num? topUpAmount;
  num? totalCash;
  num? totalBanking;
  num? totalMomo;
  num? totalVisa;
  num? totalGrabFood;
  num? totalShopeeFood;
  num? totalBefood;
  num? totalPointify;
  num? cashAmount;
  num? momoAmount;
  num? bankingAmount;
  num? visaAmount;
  num? grabFoodAmount;
  num? shopeeFoodAmount;
  num? beFoodAmount;
  num? pointifyAmount;
  num? totalSizeS;
  num? totalSizeM;
  num? totalSizeL;
  num? totalAmountSizeS;
  num? totalAmountSizeM;
  num? totalAmountSizeL;
  List<num>? timeLine;
  List<num>? totalOrderTimeLine;
  List<num>? totalAmountTimeLine;

  DayReport(
      {this.totalAmount,
      this.totalProductDiscount,
      this.totalPromotionDiscount,
      this.totalDiscount,
      this.vatAmount,
      this.finalAmount,
      this.productCosAmount,
      this.totalRevenue,
      this.averageBill,
      this.totalProduct,
      this.totalPromotionUsed,
      this.totalOrder,
      this.totalOrderInStore,
      this.totalOrderTakeAway,
      this.totalOrderDeli,
      this.totalOrderTopUp,
      this.inStoreAmount,
      this.deliAmount,
      this.takeAwayAmount,
      this.topUpAmount,
      this.totalCash,
      this.totalBanking,
      this.totalMomo,
      this.totalVisa,
      this.totalGrabFood,
      this.totalShopeeFood,
      this.totalBefood,
      this.totalPointify,
      this.cashAmount,
      this.momoAmount,
      this.bankingAmount,
      this.visaAmount,
      this.grabFoodAmount,
      this.shopeeFoodAmount,
      this.beFoodAmount,
      this.pointifyAmount,
      this.totalSizeS,
      this.totalSizeM,
      this.totalSizeL,
      this.totalAmountSizeS,
      this.totalAmountSizeM,
      this.totalAmountSizeL,
      this.timeLine,
      this.totalOrderTimeLine,
      this.totalAmountTimeLine});

  DayReport.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalProductDiscount = json['totalProductDiscount'];
    totalPromotionDiscount = json['totalPromotionDiscount'];
    totalDiscount = json['totalDiscount'];
    vatAmount = json['vatAmount'];
    finalAmount = json['finalAmount'];
    productCosAmount = json['productCosAmount'];
    totalRevenue = json['totalRevenue'];
    averageBill = json['averageBill'];
    totalProduct = json['totalProduct'];
    totalPromotionUsed = json['totalPromotionUsed'];
    totalOrder = json['totalOrder'];
    totalOrderInStore = json['totalOrderInStore'];
    totalOrderTakeAway = json['totalOrderTakeAway'];
    totalOrderDeli = json['totalOrderDeli'];
    totalOrderTopUp = json['totalOrderTopUp'];
    inStoreAmount = json['inStoreAmount'];
    deliAmount = json['deliAmount'];
    takeAwayAmount = json['takeAwayAmount'];
    topUpAmount = json['topUpAmount'];
    totalCash = json['totalCash'];
    totalBanking = json['totalBanking'];
    totalMomo = json['totalMomo'];
    totalVisa = json['totalVisa'];
    totalGrabFood = json['totalGrabFood'];
    totalShopeeFood = json['totalShopeeFood'];
    totalBefood = json['totalBefood'];
    totalPointify = json['totalPointify'];
    cashAmount = json['cashAmount'];
    momoAmount = json['momoAmount'];
    bankingAmount = json['bankingAmount'];
    visaAmount = json['visaAmount'];
    grabFoodAmount = json['grabFoodAmount'];
    shopeeFoodAmount = json['shopeeFoodAmount'];
    beFoodAmount = json['beFoodAmount'];
    pointifyAmount = json['pointifyAmount'];
    totalSizeS = json['totalSizeS'];
    totalSizeM = json['totalSizeM'];
    totalSizeL = json['totalSizeL'];
    totalAmountSizeS = json['totalAmountSizeS'];
    totalAmountSizeM = json['totalAmountSizeM'];
    totalAmountSizeL = json['totalAmountSizeL'];
    timeLine = json['timeLine'].cast<num>();
    totalOrderTimeLine = json['totalOrderTimeLine'].cast<num>();
    totalAmountTimeLine = json['totalAmountTimeLine'].cast<num>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalAmount'] = totalAmount;
    data['totalProductDiscount'] = totalProductDiscount;
    data['totalPromotionDiscount'] = totalPromotionDiscount;
    data['totalDiscount'] = totalDiscount;
    data['vatAmount'] = vatAmount;
    data['finalAmount'] = finalAmount;
    data['productCosAmount'] = productCosAmount;
    data['totalRevenue'] = totalRevenue;
    data['averageBill'] = averageBill;
    data['totalProduct'] = totalProduct;
    data['totalPromotionUsed'] = totalPromotionUsed;
    data['totalOrder'] = totalOrder;
    data['totalOrderInStore'] = totalOrderInStore;
    data['totalOrderTakeAway'] = totalOrderTakeAway;
    data['totalOrderDeli'] = totalOrderDeli;
    data['totalOrderTopUp'] = totalOrderTopUp;
    data['inStoreAmount'] = inStoreAmount;
    data['deliAmount'] = deliAmount;
    data['takeAwayAmount'] = takeAwayAmount;
    data['topUpAmount'] = topUpAmount;
    data['totalCash'] = totalCash;
    data['totalBanking'] = totalBanking;
    data['totalMomo'] = totalMomo;
    data['totalVisa'] = totalVisa;
    data['totalGrabFood'] = totalGrabFood;
    data['totalShopeeFood'] = totalShopeeFood;
    data['totalBefood'] = totalBefood;
    data['totalPointify'] = totalPointify;
    data['cashAmount'] = cashAmount;
    data['momoAmount'] = momoAmount;
    data['bankingAmount'] = bankingAmount;
    data['visaAmount'] = visaAmount;
    data['grabFoodAmount'] = grabFoodAmount;
    data['shopeeFoodAmount'] = shopeeFoodAmount;
    data['beFoodAmount'] = beFoodAmount;
    data['pointifyAmount'] = pointifyAmount;
    data['totalSizeS'] = totalSizeS;
    data['totalSizeM'] = totalSizeM;
    data['totalSizeL'] = totalSizeL;
    data['totalAmountSizeS'] = totalAmountSizeS;
    data['totalAmountSizeM'] = totalAmountSizeM;
    data['totalAmountSizeL'] = totalAmountSizeL;
    data['timeLine'] = timeLine;
    data['totalOrderTimeLine'] = totalOrderTimeLine;
    data['totalAmountTimeLine'] = totalAmountTimeLine;
    return data;
  }
}

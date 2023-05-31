class DayReport {
  String? storeId;
  num? totalAmount;
  num? totalProductDiscount;
  num? totalPromotionDiscount;
  num? totalDiscount;
  num? vatAmount;
  num? finalAmount;
  num? totalProduct;
  num? totalPromotionUsed;
  num? totalOrder;
  num? totalOrderInStore;
  num? totalOrderTakeAway;
  num? totalOrderDeli;
  num? inStoreAmount;
  num? deliAmount;
  num? takeAwayAmount;
  num? totalCash;
  num? totalBanking;
  num? totalMomo;
  num? totalVisa;
  num? cashAmount;
  num? momoAmount;
  num? bankingAmount;
  num? visaAmount;

  DayReport(
      {this.storeId,
      this.totalAmount,
      this.totalProductDiscount,
      this.totalPromotionDiscount,
      this.totalDiscount,
      this.vatAmount,
      this.finalAmount,
      this.totalProduct,
      this.totalPromotionUsed,
      this.totalOrder,
      this.totalOrderInStore,
      this.totalOrderTakeAway,
      this.totalOrderDeli,
      this.inStoreAmount,
      this.deliAmount,
      this.takeAwayAmount,
      this.totalCash,
      this.totalBanking,
      this.totalMomo,
      this.totalVisa,
      this.cashAmount,
      this.momoAmount,
      this.bankingAmount,
      this.visaAmount});

  DayReport.fromJson(Map<String, dynamic> json) {
    storeId = json['storeId'];
    totalAmount = json['totalAmount'];
    totalProductDiscount = json['totalProductDiscount'];
    totalPromotionDiscount = json['totalPromotionDiscount'];
    totalDiscount = json['totalDiscount'];
    vatAmount = json['vatAmount'];
    finalAmount = json['finalAmount'];
    totalProduct = json['totalProduct'];
    totalPromotionUsed = json['totalPromotionUsed'];
    totalOrder = json['totalOrder'];
    totalOrderInStore = json['totalOrderInStore'];
    totalOrderTakeAway = json['totalOrderTakeAway'];
    totalOrderDeli = json['totalOrderDeli'];
    inStoreAmount = json['inStoreAmount'];
    deliAmount = json['deliAmount'];
    takeAwayAmount = json['takeAwayAmount'];
    totalCash = json['totalCash'];
    totalBanking = json['totalBanking'];
    totalMomo = json['totalMomo'];
    totalVisa = json['totalVisa'];
    cashAmount = json['cashAmount'];
    momoAmount = json['momoAmount'];
    bankingAmount = json['bankingAmount'];
    visaAmount = json['visaAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['storeId'] = storeId;
    data['totalAmount'] = totalAmount;
    data['totalProductDiscount'] = totalProductDiscount;
    data['totalPromotionDiscount'] = totalPromotionDiscount;
    data['totalDiscount'] = totalDiscount;
    data['vatAmount'] = vatAmount;
    data['finalAmount'] = finalAmount;
    data['totalProduct'] = totalProduct;
    data['totalPromotionUsed'] = totalPromotionUsed;
    data['totalOrder'] = totalOrder;
    data['totalOrderInStore'] = totalOrderInStore;
    data['totalOrderTakeAway'] = totalOrderTakeAway;
    data['totalOrderDeli'] = totalOrderDeli;
    data['inStoreAmount'] = inStoreAmount;
    data['deliAmount'] = deliAmount;
    data['takeAwayAmount'] = takeAwayAmount;
    data['totalCash'] = totalCash;
    data['totalBanking'] = totalBanking;
    data['totalMomo'] = totalMomo;
    data['totalVisa'] = totalVisa;
    data['cashAmount'] = cashAmount;
    data['momoAmount'] = momoAmount;
    data['bankingAmount'] = bankingAmount;
    data['visaAmount'] = visaAmount;
    return data;
  }
}

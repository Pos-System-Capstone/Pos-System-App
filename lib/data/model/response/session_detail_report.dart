class SessionDetailReport {
  num? totalAmount;
  num? totalDiscount;
  num? finalAmount;
  num? totalOrder;
  num? totalCash;
  num? totalBanking;
  num? totalMomo;
  num? totalVisa;
  num? cashAmount;
  num? momoAmount;
  num? bankingAmount;
  num? visaAmount;

  SessionDetailReport(
      {this.totalAmount,
      this.totalDiscount,
      this.finalAmount,
      this.totalOrder,
      this.totalCash,
      this.totalBanking,
      this.totalMomo,
      this.totalVisa,
      this.cashAmount,
      this.momoAmount,
      this.bankingAmount,
      this.visaAmount});

  SessionDetailReport.fromJson(Map<String, dynamic> json) {
    totalAmount = json['totalAmount'];
    totalDiscount = json['totalDiscount'];
    finalAmount = json['finalAmount'];
    totalOrder = json['totalOrder'];
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
    data['totalAmount'] = totalAmount;
    data['totalDiscount'] = totalDiscount;
    data['finalAmount'] = finalAmount;
    data['totalOrder'] = totalOrder;
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

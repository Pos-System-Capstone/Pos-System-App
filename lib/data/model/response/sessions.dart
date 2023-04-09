class Session {
  String? id;
  String? startDateTime;
  String? endDateTime;
  String? name;
  int? numberOfOrders;
  num? currentCashInVault;
  num? totalFinalAmount;

  Session(
      {this.id,
      this.startDateTime,
      this.endDateTime,
      this.name,
      this.numberOfOrders,
      this.currentCashInVault,
      this.totalFinalAmount});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDateTime = json['startDateTime'];
    endDateTime = json['endDateTime'];
    name = json['name'];
    numberOfOrders = json['numberOfOrders'];
    currentCashInVault = json['currentCashInVault'];
    totalFinalAmount = json['totalFinalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDateTime'] = startDateTime;
    data['endDateTime'] = endDateTime;
    data['name'] = name;
    data['numberOfOrders'] = numberOfOrders;
    data['currentCashInVault'] = currentCashInVault;
    data['totalFinalAmount'] = totalFinalAmount;
    return data;
  }
}

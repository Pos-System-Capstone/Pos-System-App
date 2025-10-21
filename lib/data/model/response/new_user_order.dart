class NewUserOrder {
  int? totalOrder;
  int? totalOrderDeli;
  int? totalOrderPickUp;

  NewUserOrder({this.totalOrder, this.totalOrderDeli, this.totalOrderPickUp});

  NewUserOrder.fromJson(Map<String, dynamic> json) {
    totalOrder = json['totalOrder'];
    totalOrderDeli = json['totalOrderDeli'];
    totalOrderPickUp = json['totalOrderPickUp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalOrder'] = totalOrder;
    data['totalOrderDeli'] = totalOrderDeli;
    data['totalOrderPickUp'] = totalOrderPickUp;
    return data;
  }
}

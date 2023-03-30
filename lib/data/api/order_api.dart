import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/index.dart';

import '../../util/request.dart';

class OrderAPI {
  Future placeOrder(OrderModel order, String storeId) async {
    var dataJson = order.toJson();
    print(dataJson);
    final res = await request.post('stores/$storeId/orders', data: dataJson);
    var jsonList = res.data;
    print(jsonList);
    return jsonList;
  }

  Future<OrderResponseModel> getOrderOfStore(
      String storeId, String orderId) async {
    final res = await request.get('stores/$storeId/orders/$orderId');
    var jsonList = res.data;
    OrderResponseModel orderResponse = OrderResponseModel.fromJson(jsonList);
    return orderResponse;
  }

  Future updateOrder(
    String storeId,
    String orderId,
    String? status,
    String? paymentId,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['paymentId'] = paymentId;
    print(data);
    final res =
        await request.put('stores/$storeId/orders/$orderId', data: data);
    var json = res.data;
    return json;
  }

  Future<List<OrderInList>> getListOrderOfStore(String storeId) async {
    var params = <String, dynamic>{'page': 1, 'size': 30};
    final res =
        await request.get('stores/$storeId/orders', queryParameters: params);
    var jsonList = res.data['items'];
    List<OrderInList> listOrder = [];
    for (var item in jsonList) {
      OrderInList orderResponse = OrderInList.fromJson(item);
      listOrder.add(orderResponse);
    }
    return listOrder;
  }
}

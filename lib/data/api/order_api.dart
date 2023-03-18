import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/enums/index.dart';

import '../../util/request.dart';

class OrderAPI {
  Future placeOrder(OrderModel order, String storeId) async {
    var dataJson = order.toJson();
    if (kDebugMode) {
      print("json decode");
      print(jsonEncode(dataJson));
    }
    final res = await request.post('stores/$storeId/orders', data: dataJson);
    var jsonList = res.data;
    if (kDebugMode) {
      print(jsonList);
    }
    return jsonList;
  }

  Future<OrderResponseModel> getOrderOfStore(
      String storeId, String orderId) async {
    final res = await request.get('stores/$storeId/orders/$orderId');
    var jsonList = res.data;
    if (kDebugMode) {
      print(jsonList);
    }
    OrderResponseModel orderResponse = OrderResponseModel.fromJson(jsonList);
    return orderResponse;
  }

  Future updateOrder(
    String storeId,
    String orderId,
    String? status,
    String? paymentType,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['payment'] = paymentType;

    print(jsonEncode(data));

    final res =
        await request.put('stores/$storeId/orders/$orderId', data: data);
    var jsonList = res.data;
    if (kDebugMode) {
      print(jsonList);
    }

    return jsonList;
  }
}

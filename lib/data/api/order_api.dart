import 'package:pos_apps/data/model/index.dart';
import 'package:pos_apps/data/model/response/make_payment_response.dart';
import 'package:pos_apps/data/model/response/order_in_list.dart';
import 'package:pos_apps/data/model/response/order_response.dart';
import 'package:pos_apps/util/share_pref.dart';

import '../../util/request.dart';

class OrderAPI {
  Future placeOrder(OrderModel order, String storeId) async {
    var dataJson = order.toJson();
    final res = await request.post('stores/$storeId/orders', data: dataJson);
    var jsonList = res.data;
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
    String? paymentType,
  ) async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['paymentType'] = paymentType;
    final res =
        await request.put('stores/$storeId/orders/$orderId', data: data);
    var json = res.data;
    return json;
  }

  Future<MakePaymentResponse> makePayment(
      OrderResponseModel order, String paymentId) async {
    Account? user = await getUserInfo();
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderId'] = order.orderId;
    data['invoiceId'] = order.invoiceId;
    data['storeId'] = user?.storeId;
    data['accountId'] = user?.id;
    data['paymentId'] = paymentId;
    data['amount'] = order.finalAmount;
    data['orderDescription'] = "Thanh toán đơn hàng ${order.invoiceId} ";
    final res = await paymentRequest.post('payments', data: data);
    var json = res.data;
    MakePaymentResponse makePaymentResponse =
        MakePaymentResponse.fromJson(json);
    return makePaymentResponse;
  }

  Future<List<OrderInList>> getListOrderOfStore(String storeId,
      {bool isToday = false,
      bool isYesterday = false,
      int page = 1,
      String? orderType,
      String? orderStatus}) async {
    DateTime now = DateTime.now();
    DateTime startDate = now;
    DateTime endDate = now;
    if (isToday == true) {
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day + 1);
    } else if (isYesterday = true) {
      startDate = DateTime(now.year, now.month, now.day - 1);
      endDate = DateTime(now.year, now.month, now.day);
    } else {
      startDate = now.subtract(Duration(days: 7));
      endDate = DateTime(now.year, now.month, now.day + 1);
    }
    var params = <String, dynamic>{
      'page': page,
      'size': 20,
      'endDate': endDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
    };
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

import 'package:pos_apps/data/model/response/payment_provider.dart';

import '../../util/request.dart';
import '../model/response/order_response.dart';

class PaymentData {
  Future<List<PaymentProvider?>> getListPayment() async {
    final res = await paymentRequest.get(
      'payments/payment-providers',
    );
    var jsonList = res.data;
    List<PaymentProvider> listPayment = PaymentProvider().fromList(jsonList);

    return listPayment;
  }

  Future<PaymentMethod?> getPaymentProviderOfOrder(String orderId) async {
    final res = await paymentRequest.get(
      'payments',
      queryParameters: {'orderId': orderId},
    );
    var jsonList = res.data;
    if (jsonList == null) {
      return null;
    } else {
      PaymentMethod payment = PaymentMethod.fromJson(jsonList);
      return payment;
    }
  }

  Future<PaymentStatusResponse?> checkPayment(String orderId) async {
    final res = await paymentRequest.get(
      'check-transaction-status',
      queryParameters: {'orderId': orderId},
    );
    if (res.data == null) {
      return null;
    } else {
      PaymentStatusResponse paymentStatusResponse =
          PaymentStatusResponse.fromJson(res.data);
      return paymentStatusResponse;
    }
  }

  Future<String?> updatePayment(String orderId, String status) async {
    Map<String, dynamic> body = {
      'orderId': orderId,
      'transactionStatus': status,
    };
    final res = await paymentRequest.post(
      'payments/vietqr',
      data: body,
    );
    if (res.data == null) {
      return null;
    } else {
      return res.data.toString();
    }
  }
}

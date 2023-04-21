import 'package:pos_apps/data/model/response/payment_provider.dart';

import '../../util/request.dart';

class PaymentData {
  Future<List<PaymentProvider?>> getListPayment() async {
    final res = await paymentRequest.get(
      'payments/payment-providers',
    );
    var jsonList = res.data;
    List<PaymentProvider> listPayment = PaymentProvider().fromList(jsonList);

    return listPayment;
  }
}

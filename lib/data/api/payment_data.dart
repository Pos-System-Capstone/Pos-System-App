import 'package:pos_apps/data/model/payment.dart';
import 'package:pos_apps/data/model/response/order_response.dart';

import '../../util/request.dart';

class PaymentData {
  Future<List<PaymentModel?>> getListPayment() async {
    final res = await request.get(
      'payment-types',
    );
    var jsonList = res.data;
    List<PaymentModel> listPayment = PaymentModel().fromList(jsonList);

    return listPayment;
  }
}

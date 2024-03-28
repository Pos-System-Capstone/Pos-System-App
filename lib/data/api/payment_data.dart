import 'package:pos_apps/data/model/response/payment_provider.dart';

import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/account.dart';
import '../model/response/order_response.dart';

class PaymentData {
  Future<List<PaymentProvider?>> getListPayment() async {
    Account? userInfo = await getUserInfo();
    final res = await request.get(
      'stores/${userInfo!.storeId}/payment-types',
    );
    var jsonList = res.data;
    List<PaymentProvider?> list = [];
    for (var item in jsonList) {
      PaymentProvider res = PaymentProvider.fromJson(item);
      list.add(res);
    }
    return list;
  }
}

import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/request_pointify.dart';

import '../../../util/share_pref.dart';
import '../../model/account.dart';
import '../../model/pointify/promotion_model.dart';

class PointifyData {
  Future<List<PromotionPointify>> getListPromotionOfStore() async {
    Account? userInfo = await getUserInfo();
    final res = await requestPointify.get('stores/promotions',
        queryParameters: {
          "storeCode": userInfo?.storeCode ?? '',
          "brandCode": userInfo?.brandCode ?? ''
        });
    var jsonList = res.data;
    List<PromotionPointify> listPromotion = [];
    for (var item in jsonList) {
      PromotionPointify res = PromotionPointify.fromJson(item);
      listPromotion.add(res);
    }
    return listPromotion;
  }
}

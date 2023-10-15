import 'package:pos_apps/util/request.dart';

import '../../model/pointify/promotion_model.dart';

class PointifyData {
  Future<List<PromotionPointify>> getListPromotionOfPointify() async {
    final res = await pointifyRequest.get(
      'stores/promotions?storeCode=DC-VH&brandCode=DeerCoffee',
    );
    var jsonList = res.data;
    List<PromotionPointify> listPromotion =
        PromotionPointify().fromList(jsonList);

    return listPromotion;
  }
}

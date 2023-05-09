import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/index.dart';
import '../model/response/promotion.dart';

class PromotionData {
  Future<List<Promotion>> getListPromotionOfStore() async {
    Account? userInfo = await getUserInfo();
    final res = await request.get(
      'stores/${userInfo!.storeId}/promotion',
    );
    var jsonList = res.data;
    List<Promotion> listPromotion = [];
    for (var item in jsonList) {
      Promotion res = Promotion.fromJson(item);
      listPromotion.add(res);
    }
    return listPromotion;
  }
}

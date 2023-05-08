import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/index.dart';
import '../model/response/promotion.dart';

class PromotionData {
  Future<List<Promotion>> getListPromotionOfStore() async {
    Account? userInfo = await getUserInfo();
    var params = <String, dynamic>{
      'page': 1,
      'size': 100,
    };
    final res = await request.get('stores/${userInfo!.storeId}/promotion',
        queryParameters: params);
    var jsonList = res.data['items'];
    List<Promotion> listPromotion = [];
    for (var item in jsonList) {
      Promotion res = Promotion.fromJson(item);
      listPromotion.add(res);
    }
    return listPromotion;
  }
}

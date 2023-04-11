import 'package:pos_apps/data/model/response/sessions.dart';

import '../../util/request.dart';
import '../../util/share_pref.dart';
import '../model/account.dart';

class SessionAPI {
  Future<List<Session>> getListSessionOfStore() async {
    DateTime now = DateTime.now();

    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = DateTime(now.year, now.month, now.day + 1);
    Account? userInfo = await getUserInfo();
    var params = <String, dynamic>{
      'page': 1,
      'size': 20,
      'endDate': endDate.toIso8601String(),
      'startDate': startDate.toIso8601String(),
    };

    final res = await request.get('stores/${userInfo!.storeId}/sessions',
        queryParameters: params);
    var jsonList = res.data['items'];
    List<Session> listSession = [];
    for (var item in jsonList) {
      Session orderResponse = Session.fromJson(item);
      listSession.add(orderResponse);
    }
    return listSession;
  }
}
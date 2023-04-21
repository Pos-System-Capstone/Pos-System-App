import 'package:flutter/foundation.dart';
import 'package:pos_apps/data/model/response/store.dart';
import 'package:pos_apps/util/request.dart';

import '../../util/share_pref.dart';
import '../model/account.dart';

class StoreData {
  Future<StoreModel?> getStoreDetail() async {
    try {
      Account? userInfo = await getUserInfo();
      var response = await request.get('stores/${userInfo!.storeId}');
      if (response.statusCode == 200) {
        StoreModel store = StoreModel.fromJson(response.data);
        return store;
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }
}

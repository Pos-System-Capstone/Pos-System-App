import 'package:flutter/foundation.dart';
import 'package:pos_apps/model/index.dart';

import '../util/request.dart';

class MenuData {
  Future<Menu?> getMenuOfStore() async {
    final res = await request.get(
      'stores/menus/products',
    );
    var jsonList = res.data;
    if (kDebugMode) {
      print(jsonList);
    }
    //metaDataDTO = MetaDataDTO.fromJson(res.data["metadata"]);
    Menu menu = Menu.fromJson(jsonList);
    return menu;
  }
}

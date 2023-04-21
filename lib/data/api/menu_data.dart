import 'package:pos_apps/data/model/index.dart';

import '../../util/request.dart';

class MenuData {
  Future<Menu?> getMenuOfStore() async {
    final res = await request.get(
      'stores/menus',
    );
    var jsonList = res.data;
    Menu menu = Menu.fromJson(jsonList);
    return menu;
  }
}

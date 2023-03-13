import 'package:get/get.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/index.dart';
import '../data/model/account.dart';
import '../routes/routes_constrants.dart';

class LoginViewModel extends BaseViewModel {
  AccountData dao = AccountData();
  late Account userDTO;

  Future<Account?> posLogin(String userName, String password) async {
    Account? userDTO = await dao.login(userName, password);
    print(userDTO!.name);
    if (userDTO != null) {
      setUserInfo(userDTO);
    }
    return userDTO;
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await Get.offAllNamed(RouteHandler.LOGIN);
  }
}

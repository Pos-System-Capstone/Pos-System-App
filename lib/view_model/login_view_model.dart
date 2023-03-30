import 'package:get/get.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api/index.dart';
import '../data/model/account.dart';
import '../enums/view_status.dart';
import '../routes/routes_constrants.dart';
import '../services/realtime_database.dart';

class LoginViewModel extends BaseViewModel {
  AccountData dao = AccountData();
  Account? userDTO;

  void posLogin(String userName, String password) async {
    try {
      setState(ViewStatus.Loading);
      userDTO = await dao.login(userName, password);
      print(userDTO!.name);
      if (userDTO != null) {
        setUserInfo(userDTO!);
        setState(ViewStatus.Completed);
        Get.offAllNamed(RouteHandler.HOME);
      }
    } catch (e) {
      setState(ViewStatus.Error);
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    await Get.offAllNamed(RouteHandler.LOGIN);
  }
}

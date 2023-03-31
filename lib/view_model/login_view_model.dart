import 'package:get/get.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Widgets/Dialogs/other_dialogs/dialog.dart';
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
      showLoadingDialog();
      dao.login(userName, password).then((value) => {
            userDTO = value,
            if (userDTO == null)
              {
                setState(ViewStatus.Error),
                hideDialog(),
                showAlertDialog(
                    title: "Login Failed",
                    content: "Please check your username and password")
              }
            else
              {
                print(userDTO!.name),
                setUserInfo(userDTO!),
                setState(ViewStatus.Completed),
                hideDialog(),
                Get.offAllNamed(RouteHandler.HOME)
              }
          });
    } catch (e) {
      setState(ViewStatus.Error);
    }
  }

  Future<void> logout() async {
    userDTO = null;
    deleteUserInfo();
    await Get.offAllNamed(RouteHandler.LOGIN);
  }
}

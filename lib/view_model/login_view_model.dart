import 'package:pos_apps/model/dto/index.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';

import '../data/account_data.dart';
import '../model/account.dart';

class LoginViewModel extends BaseViewModel {
  AccountData dao = AccountData();
  late Account userDTO;

  Future<Account?> posLogin(String userName, String password) async {
    Account? userDTO = await dao.login(userName, password);
    if (userDTO != null) {
      setUserInfo(userDTO);
    }
    return userDTO;
  }
}

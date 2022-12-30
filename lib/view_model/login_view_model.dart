import 'package:pos_apps/model/dao/account_dao.dart';
import 'package:pos_apps/model/dto/index.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';

class LoginViewModel extends BaseViewModel {
  AccountDAO dao = AccountDAO();
  late AccountDTO userDTO;

  Future<AccountDTO?> posLogin(String userName, String password) async {
    AccountDTO? userDTO = await dao.login(userName, password);
    if (userDTO != null) {
      setUserInfo(userDTO);
    }
    return userDTO;
  }
}

import 'package:get/get.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/view_model/index.dart';
import '../data/api/index.dart';
import '../data/model/account.dart';
import '../enums/view_status.dart';
import '../routes/routes_constraints.dart';
import '../views/widgets/other_dialogs/dialog.dart';

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
                    title: "Đăng nhập thất bại",
                    content: "Vui lòng kiểm tra lại tài khoản và mật khẩu")
              }
            else
              {
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
    Get.snackbar("Đăng xuất", "Đăng xuất thành công");
    await deleteUserInfo();
    await Get.offAllNamed(RouteHandler.LOGIN);
  }
}

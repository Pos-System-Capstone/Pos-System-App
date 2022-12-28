import 'package:get/get.dart';
import 'package:pos_apps/model/dao/account_dao.dart';

import '../routes/routes_constrants.dart';
import '../util/share_pref.dart';
import 'index.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    AccountDAO accountDAO = AccountDAO();
    await Future.delayed(const Duration(seconds: 3));
    bool isFirstOnBoard = await getIsFirstOnboard() ?? true;
    bool hasLoggedInUser = await accountDAO.isUserLoggedIn();

    if (!hasLoggedInUser) {
      Get.offAndToNamed(RouteHandler.LOGIN);
    } else if (true) {
      Get.offAndToNamed(RouteHandler.HOME);
    }
  }
}

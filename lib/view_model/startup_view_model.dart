import 'package:get/get.dart';

import '../routes/routes_constrants.dart';
import '../util/share_pref.dart';
import 'index.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    // AccountDAO _accountDAO = AccountDAO();
    await Future.delayed(const Duration(seconds: 3));
    bool isFirstOnBoard = await getIsFirstOnboard() ?? true;
    // bool hasLoggedInUser = await _accountDAO.isUserLoggedIn();

    if (false) {
      Get.offAndToNamed(RouteHandler.ONBOARD);
    }
    // else if (true) {
    //   Get.offAndToNamed(RouteHandler.HOME);
    // }
    else {
      Get.offAndToNamed(RouteHandler.NAV);
    }
  }
}

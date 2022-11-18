import 'package:get/get.dart';

import '../Routes/routes_constrants.dart';
import '../Utils/sharePrefs.dart';
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

    if (isFirstOnBoard) {
      Get.offAndToNamed(RouteHandler.ONBOARD);
    }
    // else if (true) {
    //   Get.offAndToNamed(RouteHandler.HOME);
    // }
    else {
      Get.offAndToNamed(RouteHandler.LOGIN);
    }
  }
}

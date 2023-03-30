import 'package:get/get.dart';
import 'package:pos_apps/routes/route_helper.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';

import '../data/api/index.dart';
import '../routes/routes_constrants.dart';
import '../util/share_pref.dart';
import 'index.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    AccountData accountDAO = AccountData();
    await Future.delayed(const Duration(seconds: 1));
    bool hasLoggedInUser = await accountDAO.isUserLoggedIn();
    print(hasLoggedInUser);

    if (!hasLoggedInUser) {
      Get.offNamed(RouteHandler.LOGIN);
    } else if (true) {
      Get.offNamed(RouteHandler.HOME);
    }
  }
}

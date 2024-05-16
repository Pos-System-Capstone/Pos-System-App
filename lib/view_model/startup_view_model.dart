import 'package:get/get.dart';

import '../routes/routes_constraints.dart';
import '../util/request.dart';
import '../util/share_pref.dart';
import 'index.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    var token = await getToken();
    if (false) {
      requestObj.setToken = token;
      await Get.find<MenuViewModel>().getMenuOfStore();
      await Get.offAllNamed(RouteHandler.HOME);
    } else {
      await Get.offNamed(RouteHandler.LOGIN);
    }
  }
}

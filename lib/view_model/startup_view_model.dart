import 'package:get/get.dart';

import '../routes/routes_constrants.dart';
import 'index.dart';

class StartUpViewModel extends BaseViewModel {
  StartUpViewModel() {
    handleStartUpLogic();
  }
  Future handleStartUpLogic() async {
    await Future.delayed(const Duration(seconds: 1));
    Get.offNamed(RouteHandler.LOGIN);
  }
}

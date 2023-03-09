// Future setUp() async {
//   await Firebase.initializeApp();
//   PushNotificationService ps = PushNotificationService.getInstance();
//   await ps.init();
//   if (!kIsWeb) {
//     await DynamicLinkService.initDynamicLinks();
//   }
// }

import 'package:get/get.dart';
import 'package:pos_apps/view_model/cart_view_model.dart';
import 'package:pos_apps/view_model/menu_view_model.dart';
import 'package:pos_apps/view_model/order_view_model.dart';

import 'view_model/index.dart';
import 'view_model/login_view_model.dart';
import 'view_model/product_view_model.dart';

void createRouteBindings() async {
  Get.put(RootViewModel());
  Get.put(LoginViewModel());
  Get.put(MenuViewModel());
  Get.put(StartUpViewModel());
  Get.put(OrderViewModel());
  Get.put(CartViewModel());
}

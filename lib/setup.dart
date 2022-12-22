// Future setUp() async {
//   await Firebase.initializeApp();
//   PushNotificationService ps = PushNotificationService.getInstance();
//   await ps.init();
//   if (!kIsWeb) {
//     await DynamicLinkService.initDynamicLinks();
//   }
// }

import 'package:get/get.dart';
import 'package:pos_apps/view_model/order_view_model.dart';

import 'view_model/index.dart';

void createRouteBindings() async {
  Get.put(StartUpViewModel());
  // Get.put(RootViewModel());
  // Get.put(HomeViewModel());
  // Get.put(AccountViewModel());
  // Get.put(OrderHistoryViewModel());
  // Get.put(ProductFilterViewModel());
  // Get.put(TransactionViewModel());
  // Get.put(BlogsViewModel());
  // Get.put(GiftViewModel());
  Get.put(OrderViewModel());
}

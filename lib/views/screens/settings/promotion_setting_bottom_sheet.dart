import 'package:get/get.dart';
import 'package:pos_apps/views/screens/settings/promotion_info.dart';

import 'product_attributes.dart';

void showPromotionConfigBottomSheet() {
  Get.dialog(
    // isDismissible: true,
    PromotionInfoScreen(),
  );
}

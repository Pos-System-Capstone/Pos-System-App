import 'package:get/get.dart';
import 'package:pos_apps/views/screens/settings/promotion_info.dart';

import 'product_attributes.dart';

void showPromotionConfigBottomSheet() {
  Get.bottomSheet(
    // isDismissible: true,
    isScrollControlled: true,
    PromotionInfoScreen(),
  );
}

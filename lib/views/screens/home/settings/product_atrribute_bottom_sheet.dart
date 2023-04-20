import 'package:get/get.dart';
import 'package:pos_apps/views/screens/home/settings/product_attrubutes.dart';

void showProductAttributesBottomSheet() {
  Get.bottomSheet(
    // isDismissible: true,
    isScrollControlled: true,
    ProductAttributeScreen(),
  );
}

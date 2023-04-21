import 'package:get/get.dart';

import 'product_attrubutes.dart';

void showProductAttributesBottomSheet() {
  Get.bottomSheet(
    // isDismissible: true,
    isScrollControlled: true,
    ProductAttributeScreen(),
  );
}

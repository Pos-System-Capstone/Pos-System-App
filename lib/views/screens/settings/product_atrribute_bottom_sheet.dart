import 'package:get/get.dart';

import 'product_attributes.dart';

void showProductAttributesBottomSheet() {
  Get.bottomSheet(
    // isDismissible: true,
    isScrollControlled: true,
    ProductAttributeScreen(),
  );
}

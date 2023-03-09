import 'package:get/get.dart';

import '../helper/responsive_helper.dart';

class Dimensions {
  static double fontSizeExtraSmall = Get.context!.width >= 1300
      ? 14
      : ResponsiveHelper.isSmallTab()
          ? 8
          : 10;
  static double fontSizeSmall = Get.context!.width >= 1300
      ? 16
      : ResponsiveHelper.isSmallTab()
          ? 10
          : 12;
  static double fontSizeDefault = Get.context!.width >= 1300
      ? 18
      : ResponsiveHelper.isSmallTab()
          ? 12
          : 14;
  static double fontSizeLarge = Get.context!.width >= 1300
      ? 20
      : ResponsiveHelper.isSmallTab()
          ? 14
          : 16;
  static double fontSizeExtraLarge = Get.context!.width >= 1300
      ? 22
      : ResponsiveHelper.isSmallTab()
          ? 16
          : 18;
  static double fontSizeOverLarge = Get.context!.width >= 1300
      ? 28
      : ResponsiveHelper.isSmallTab()
          ? 20
          : 24;
  // static double fontSizeExtraSmall = ResponsiveHelper.isTab(Get.context) ? 12 : 10;
  // static double fontSizeSmall = ResponsiveHelper.isTab(Get.context) ? 14 : 12;
  // static double fontSizeDefault = ResponsiveHelper.isTab(Get.context) ? 16 : 14;
  // static double fontSizeLarge = ResponsiveHelper.isTab(Get.context) ? 18 : 16;
  // static double fontSizeExtraLarge = ResponsiveHelper.isTab(Get.context) ? 20 : 18;
  // static double fontSizeOverLarge = ResponsiveHelper.isTab(Get.context) ? 25 : 24;

  static double paddingSizeExtraSmall = ResponsiveHelper.isSmallTab() ? 3 : 5.0;
  static double paddingSizeSmall = ResponsiveHelper.isSmallTab() ? 7 : 10.0;
  static double paddingSizeDefault = ResponsiveHelper.isSmallTab() ? 12 : 15.0;
  static double paddingSizeLarge = ResponsiveHelper.isSmallTab() ? 18 : 20.0;
  static double paddingSizeExtraLarge =
      ResponsiveHelper.isSmallTab() ? 20 : 25.0;

  // static const double PADDING_SIZE_EXTRA_SMALL = 5.0;
  // static const double PADDING_SIZE_SMALL = 10.0;
  // static const double PADDING_SIZE_DEFAULT = 15.0;
  // static const double PADDING_SIZE_LARGE = 20.0;
  // static const double PADDING_SIZE_EXTRA_LARGE = 25.0;

  static const double RADIUS_SMALL = 5.0;
  static const double RADIUS_DEFAULT = 10.0;
  static const double RADIUS_LARGE = 15.0;
  static double radiusExtraLarge = ResponsiveHelper.isSmallTab() ? 15 : 20.0;

  static const double WEB_MAX_WIDTH = 1170;
}

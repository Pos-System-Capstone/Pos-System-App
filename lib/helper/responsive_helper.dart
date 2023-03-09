import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';

class ResponsiveHelper {
  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTabHorizontal(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 1000) {
      return true;
    } else {
      return false;
    }
  }

  static int getLen(context) {
    final size = MediaQuery.of(context).size.height;
    if (size <= 700) {
      return 6;
    } else if (size > 700 && size < 1100) {
      return 8;
    } else {
      return 12;
    }
  }

  static bool isSmallTab() =>
      ResponsiveHelper.isTab(Get.context) && Get.context!.width < 900;
}

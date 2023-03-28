import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/account.dart';

Future<bool> setIsFirstOnboard(bool isFirstOnboard) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('isFirstOnBoard', isFirstOnboard);
}

Future<bool?> getIsFirstOnboard() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isFirstOnBoard');
}

Future setThemeColorIndex(int colorIndex) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setInt('colorIndex', colorIndex);
}

Future<int?> getThemeColorIndex() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('colorIndex');
}

//Return true if token is expire
Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //convert datetime type to the same format to compare
    DateTime now =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateTime.now().toString());
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(prefs.getString('expireDate') ?? now.toString());

    return tempDate.compareTo(now) < 0;
  } catch (e) {
    return true;
  }
}

Future<bool> setToken(String value, String userRole) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String expireDate = DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

  if (userRole == "" && value == "") {
    return prefs.setString('token', value);
  }

  //Config expire time of token based on role of user login to system
  if (userRole == UserRole.Staff.toString()) {
    expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .format(DateTime.now().add(Duration(days: 1)));
  } else {
    expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .format(DateTime.now().add(Duration(hours: 3)));
  }

  prefs.setString('expireDate', expireDate.toString());
  return prefs.setString('token', value);
}

Future<String> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token') ?? "";
}

Future<bool> setThemeColor(int idx) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setInt('themeColor', idx);
}

Future<int?> getThemeColor() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('themeColor');
}

Future<bool> setThemeMode(bool isDark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setBool('darkMode', isDark);
}

Future<bool?> getThemeMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('darkMode');
}

Future<void> setUserInfo(Account userDTO) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userInfo = userDTO.toJson();
  prefs.setString("userInfo", jsonEncode(userInfo));
}

Future<Account?> getUserInfo() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? userData = pref.getString("userInfo");
  Account? userInfo;
  if (userData != null) {
    userInfo = Account.fromJson(jsonDecode(userData));
  }
  return userInfo;
}

Future<void> deleteUserInfo() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("userInfo");
}

Future<int?> getTableNumber() async {
  int? number = -1;
  final SharedPreferences pref = await SharedPreferences.getInstance();
  if (pref.containsKey("numberOfTable")) {
    number = pref.getInt("numberOfTable");
  }

  return number;
}

Future<bool> setBillPrinter(String url) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("billPrinter", url);
}

Future<String?> getBillPrinter() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("billPrinter");
}

Future<bool> setProductPrinter(String url) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString("productPrinter", url);
}

Future<String?> getProductPrinter() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("productPrinter");
}

Future<void> deletePrinterDeviceIP() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove("billPrinter");
}

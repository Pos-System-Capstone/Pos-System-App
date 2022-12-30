import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:pos_apps/enums/index.dart';
import 'package:pos_apps/model/dto/account_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<bool> expireToken() async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss")
        .parse(prefs.getString('expireDate') ?? DateTime.now().toString());
    return tempDate.compareTo(DateTime.now()) < 0;
  } catch (e) {
    return true;
  }
}

Future<bool> setToken(String value, String userRole) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String expireDate = DateFormat("yyyy-MM-dd hh:mm:ss")
      .format(DateTime.now().add(Duration(seconds: 0)));

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

Future<void> setUserInfo(AccountDTO userDTO) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final userInfo = userDTO.toJson();
  prefs.setString("userInfo", jsonEncode(userInfo));
}

Future<AccountDTO?> getUserInfo() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  String? userData = pref.getString("userInfo");
  AccountDTO? userInfo;
  if (userData != null) {
    userInfo = AccountDTO.fromJson(jsonDecode(userData));
  }
  return userInfo;
}

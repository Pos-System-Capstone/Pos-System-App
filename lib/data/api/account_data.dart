import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/share_pref.dart';
import '../model/index.dart';

class AccountData {
  Future<Account?> login(String username, String password) async {
    try {
      Response response = await request.post("auth/login",
          data: {"username": username, "password": password});

      if (response.statusCode?.compareTo(200) == 0) {
        final user = response.data;
        final accessToken = user['accessToken'] as String;
        final userRole = user['role'] as String;

        requestObj.setToken = accessToken;
        paymentRequestObj.setToken = accessToken;
        setToken(accessToken, userRole);

        Account userResponse = Account.fromJson(user);
        return userResponse;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error login (account_dao): ${e.toString()}');
      }
    }
    return null;
  }

  Future<bool> isUserLoggedIn() async {
    bool isTokenExpired = await expireToken();
    String token = await getToken();
    if (isTokenExpired) {
      setToken("", "");
      return false;
    }
    if (!isTokenExpired && token.isNotEmpty) {
      requestObj.setToken = token;
    }
    return token.isNotEmpty;
  }
}

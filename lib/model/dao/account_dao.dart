import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pos_apps/model/DAO/index.dart';
import 'package:pos_apps/model/DTO/account_dto.dart';
import 'package:pos_apps/util/share_pref.dart';
import 'package:pos_apps/util/request.dart';

class AccountDAO extends BaseDAO {
  Future<AccountDTO?> login(String username, String password) async {
    try {
      Response response = await request.post("auth/login",
          data: {"username": username, "password": password});

      final user = response.data;
      final accessToken = user['accessToken'] as String;
      requestObj.setToken = accessToken;
      setToken(accessToken);

      AccountDTO userDTO = AccountDTO.fromJson(user);
      return userDTO;
    } catch (e) {
      debugPrint('Error login: ${e.toString()}');
      return null;
    }
  }

  Future<bool> isUserLoggedIn() async {
    bool isTokenExpired = await expireToken();
    String token = await getToken();

    if (isTokenExpired) {
      return false;
    } else if (!isTokenExpired && token.isNotEmpty) {
      requestObj.setToken = token;
    }
    return token.isNotEmpty;
  }
}

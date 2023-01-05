import 'package:dio/dio.dart';
import 'package:pos_apps/model/dao/index.dart';
import 'package:pos_apps/model/dto/account_dto.dart';
import 'package:pos_apps/util/request.dart';
import 'package:pos_apps/util/share_pref.dart';

class AccountDAO extends BaseDAO {
  Future<AccountDTO?> login(String username, String password) async {
    try {
      Response response = await request.post("auth/login",
          data: {"username": username, "password": password});

      if (response.statusCode?.compareTo(200) == 0) {
        final user = response.data;
        final accessToken = user['accessToken'] as String;
        final userRole = user['role'] as String;

        requestObj.setToken = accessToken;
        setToken(accessToken, userRole);

        AccountDTO userDTO = AccountDTO.fromJson(user);
        return userDTO;
      } else {
        return null;
      }
    } catch (e) {
      print('Error login (account_dao): ${e.toString()}');
    }
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

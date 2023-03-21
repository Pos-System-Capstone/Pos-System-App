import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:pos_apps/widgets/Dialogs/other_dialogs/dialog.dart';
import 'package:pos_apps/widgets/dialogs/login_dialogs/login_dialogs.dart';

import '../routes/routes_constrants.dart';

Map<String, dynamic> convertToQueryParams(
    [Map<String, dynamic> params = const {}]) {
  Map<String, dynamic> queryParams = Map.from(params);
  return queryParams.map<String, dynamic>(
    (key, value) => MapEntry(
        key,
        value == null
            ? null
            : (value is List)
                ? value.map<String>((e) => e.toString()).toList()
                : value.toString()),
  );
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class ExpiredException extends AppException {
  ExpiredException([String? message]) : super(message, "Token Expired: ");
}

class CustomInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'REQUEST[${options.method}] => PATH: ${options.path} HEADER: ${options.headers.toString()}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    print('DATA: ${response.data}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
// or new Dio with a BaseOptions instance.

class MyRequest {
  static BaseOptions options = BaseOptions(
      // baseUrl: 'https://api.pos-tech.systems/api/v1/',
      baseUrl: 'http://120.72.85.82/api/v1/',
      headers: {
        Headers.contentTypeHeader: "application/json",
        Headers.acceptHeader: "text/plain"
      },
      sendTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 5));
  late Dio _inner;
  MyRequest() {
    _inner = Dio(options);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        return handler.next(e); // continue
      },
      onError: (e, handler) async {
        print(e.response?.statusCode);
        if (e.response?.statusCode == 400) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 500) {
          showAlertDialog(
            title: "Lỗi hệ thống",
            content: e.response?.data["Error"],
          );
          Get.offAllNamed(RouteHandler.LOGIN);
        } else if (e.response?.statusCode == 403) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 404) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 500) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 503) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        }
        print(e.response?.data["Error"]);
        handler.next(e);
      },
    ));
  }

  Dio get request {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = MyRequest();
final request = requestObj.request;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

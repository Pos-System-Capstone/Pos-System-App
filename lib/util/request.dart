// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import '../routes/routes_constraints.dart';
import '../views/widgets/other_dialogs/dialog.dart';

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

  @override
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

class UnauthorizedException extends AppException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
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
    if (kDebugMode) {
      print(
          'REQUEST[${options.method}] => PATH: ${options.path} HEADER: ${options.headers.toString()}');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    }
    if (kDebugMode) {
      print('DATA: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    return super.onError(err, handler);
  }
}
// or new Dio with a BaseOptions instance.

class MyRequest {
  static BaseOptions options = BaseOptions(
      baseUrl: 'https://admin.reso.vn/api/v1/',
      // baseUrl: 'https://localhost:7131/api/v1/',
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
        if (e.response?.statusCode == 400) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 500) {
          Future<bool> res = showConfirmDialog(
            title: "Lỗi hệ thống",
            content: "Vui lòng đăng nhập lại",
          );
          res.then((value) => Get.offAllNamed(RouteHandler.LOGIN));
        } else if (e.response?.statusCode == 401) {
          await showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
          Get.offAllNamed(RouteHandler.LOGIN);
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        }
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

class PaymentRequest {
  static BaseOptions options = BaseOptions(
      // baseUrl: 'https://localhost:7102/api/v1/',
      baseUrl: 'https://payment.endy.bio/api/v1/',
      headers: {
        Headers.contentTypeHeader: "application/json",
        Headers.acceptHeader: "text/plain",
      },
      sendTimeout: Duration(seconds: 15),
      receiveTimeout: Duration(seconds: 5));
  late Dio _inner;

  PaymentRequest() {
    _inner = Dio(options);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        return handler.next(e); // continue
      },
      onError: (e, handler) async {
        if (kDebugMode) {
          print(e.response?.statusCode);
        }
        if (e.response?.statusCode == 400) {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        } else if (e.response?.statusCode == 500) {
          Future<bool> res = showConfirmDialog(
            title: "Lỗi hệ thống " + e.response?.data["StatusCode"],
            content: e.response?.data["Error"] + "/n Vui lòng đăng nhập lại",
          );
          res.then((value) => Get.offAllNamed(RouteHandler.LOGIN));
        } else {
          showAlertDialog(
            title: "Lỗi",
            content: e.response?.data["Error"],
          );
        }
        // handler.next(e);
      },
    ));
  }

  Dio get paymentRequest {
    return _inner;
  }

  set setToken(token) {
    options.headers["Authorization"] = "Bearer $token";
  }
}

final requestObj = MyRequest();
final request = requestObj.request;

final paymentRequestObj = PaymentRequest();
final paymentRequest = paymentRequestObj.paymentRequest;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

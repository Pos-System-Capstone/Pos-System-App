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
  Future<void> onError(err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print(
          'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    }
    return super.onError(err, handler);
  }
}
// or new Dio with a BaseOptions instance.

class RequestPointify {
  static BaseOptions options = BaseOptions(
      baseUrl: 'https://api-pointify.reso.vn/api/',
      // baseUrl: 'https://localhost:7131/api/',
      headers: {
        Headers.contentTypeHeader: "application/json",
        Headers.acceptHeader: "text/plain",
      },
      connectTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15));

  late Dio _inner;
  RequestPointify() {
    _inner = Dio(options);
    _inner.interceptors.add(CustomInterceptors());
    _inner.interceptors.add(InterceptorsWrapper(
      onResponse: (e, handler) {
        return handler.next(e); // continue
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 400) {
          await showAlertDialog(
              title: "Lỗi", content: e.response?.data["description"]);
        } else if (e.response?.statusCode == 500) {
          showAlertDialog(
            title: "Lỗi hệ thống",
            content:
                "Lỗi xảy ra do hệ thống gặp vấn đề, vui lòng thử lại sau hoặc là tắt ứng dụng và mở lại",
          );
        } else if (e.response?.statusCode == 401) {
          await showAlertDialog(
            title: "Lỗi",
            content: "Phiên đăng nhập hết hạn, vui lòng đăng nhập lại",
          );
          Get.offAllNamed(RouteHandler.LOGIN);
        } else {
          showAlertDialog(
              title: "Lỗi",
              content: e.response?.data["description"].toString() ??
                  'Lỗi không rõ nguyên nhân');
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

final requestPointifyObj = RequestPointify();
final requestPointify = requestPointifyObj.request;

class RequestPointifyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies_db_bloc/data/common/secret_components.dart';
import 'package:movies_db_bloc/presenter/utils/constants.dart';
import 'package:movies_db_bloc/presenter/utils/strings.dart';

class AppProvider extends InheritedWidget {
  AppProvider({
    @required this.appName,
    @required this.flavorName,
    @required this.apiBaseUrl,
    @required this.secretPath,
    @required Widget child,
  })  : constants = Constants(),
        strings = Strings(),
        secretLoader = SecretLoader(secretPath: secretPath),
        super(child: child);

  final String appName;
  final String flavorName;
  final String apiBaseUrl;
  final String secretPath;
  final Constants constants;
  final Strings strings;
  final SecretLoader secretLoader;

  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = new BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: 50000,
      receiveTimeout: 30000,
    );
    Dio dio = new Dio(options);
    dio.interceptors.addAll(<Interceptor>[_loggingInterceptor()]);

    return dio;
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(onRequest: (RequestOptions options) {
      // Do something before request is sent
      debugPrint("\n"
          "Request ${options.uri} \n"
          "-- headers --\n"
          "${options.headers.toString()} \n"
          "-- payload --\n  x"
          "${jsonEncode(options.data)} \n"
          "");

      return options; //continue
      // If you want to resolve the request with some custom data，
      // you can return a `Response` object or return `dio.resolve(data)`.
      // If you want to reject the request with a error message,
      // you can return a `DioError` object or return `dio.reject(errMsg)`
    }, onResponse: (Response response) {
      // Do something with response data
      debugPrint("\n"
          "Response ${response.request.uri} \n"
          "-- headers --\n"
          "${response.headers.toString()} \n"
          "-- payload --\n"
          "${jsonEncode(response.data)} \n"
          "");
      return response; // continue
    }, onError: (DioError e) {
      // Do something with response error
      return e; //continue
    });
  }

  static AppProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

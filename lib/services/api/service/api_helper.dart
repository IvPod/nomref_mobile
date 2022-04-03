import 'dart:io';

import 'package:dio/dio.dart';

class ApiHelper {
  Dio _dio;
  final BaseOptions _options = BaseOptions(
    baseUrl: 'http://localhost:5000/api',
    connectTimeout: 10000,
    receiveTimeout: 10000,
    responseType: ResponseType.json,
    contentType: Headers.jsonContentType,
  );

  ApiHelper._internal() {
    _dio = Dio(_options);
  }
  factory ApiHelper() => _apiHelper;
  static final ApiHelper _apiHelper = ApiHelper._internal();

  void addAuthorizationHeader(String token) => _options.headers
      .addAll({HttpHeaders.authorizationHeader: 'Bearer $token'});

  void removeAuthorizationHeader() =>
      _options.headers.remove(HttpHeaders.authorizationHeader);

  Future<dynamic> get(String url,
      {Map<String, dynamic> queryParameters}) async {
    final response =
        await _dio.get(url, queryParameters: queryParameters);
    return response?.data;
  }

  Future<dynamic> post(String url, dynamic data) async {
    final response = await _dio.post(url, data: data);
    return response?.data;
  }

  Future<dynamic> put(String url, dynamic data) async {
    final response = await _dio.put(url, data: data);
    return response?.data;
  }

  Future<dynamic> delete(String url) async {
    final response = await _dio.delete(url);
    return response?.data;
  }
}

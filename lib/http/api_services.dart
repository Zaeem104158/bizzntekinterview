import 'dart:developer';

import 'package:bizzinterview/http/api_exception.dart';
import 'package:dio/dio.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService _instance = ApiService._privateConstructor();

  factory ApiService() {
    return _instance;
  }

  final Dio _dio = Dio();

  Future<List<dynamic>> get(
    String endpoint,
  ) async {
    log("Api End Point: $endpoint");

    try {
      final response = await _dio.get(
        endpoint,
      );
      log("Api Response: $response");
      return response.data as List<dynamic>;
    } on DioException catch (error) {
      throw ApiException.fromDioError(error);
    }
  }
}

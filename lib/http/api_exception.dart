import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException("Connection timeout");
      case DioExceptionType.sendTimeout:
        return ApiException("Send timeout");
      case DioExceptionType.receiveTimeout:
        return ApiException("Receive timeout");
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 401:
            return ApiException(
                "Unauthorized access. Please log or create a account.");
          case 403:
            return ApiException(
                "Forbidden request. You do not have permission.");
          case 404:
            return ApiException(
                "Resource not found or user is not registered.");
          case 500:
            return ApiException("Server error. Please try again later.");
          default:
            return ApiException("Received HTTP error: $statusCode");
        }
      case DioExceptionType.cancel:
        return ApiException("Request cancelled");
      case DioExceptionType.unknown:
      default:
        return ApiException("Unexpected error occurred");
    }
  }

  @override
  String toString() => "ApiException: $message";
}

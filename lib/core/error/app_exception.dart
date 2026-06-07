import 'package:dio/dio.dart';

/// A single, user friendly error type used across the app.
///
/// The data layer converts low level [DioException]s into this so the
/// presentation layer never has to know about the network package.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException('The connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const AppException('No internet connection.');
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) {
          return const AppException('Recipe not found.');
        }
        return AppException('Server error${code != null ? ' ($code)' : ''}.');
      case DioExceptionType.cancel:
        return const AppException('Request cancelled.');
      default:
        return const AppException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => message;
}

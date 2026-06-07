import 'package:dio/dio.dart';

import 'api_config.dart';

/// Builds the shared [Dio] instance with base options used for every request.
class DioClient {
  const DioClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        responseType: ResponseType.json,
        headers: {'Accept': 'application/json'},
      ),
    );
    return dio;
  }
}

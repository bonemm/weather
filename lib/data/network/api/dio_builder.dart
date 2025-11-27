import 'package:dio/dio.dart';

class DioBuilder {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org',
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 7),
      sendTimeout: const Duration(seconds: 7),
    ),
  );

  void addIntercepror(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);
  }

  Dio get dio => _dio;
}

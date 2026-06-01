import 'package:dio/dio.dart';

class DioBuilder {
  // Open-Meteo serves forecast and geocoding from different hosts, so each
  // request supplies its own absolute URL rather than relying on a baseUrl.
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 7),
      sendTimeout: const Duration(seconds: 7),
    ),
  );

  Dio get dio => _dio;
}

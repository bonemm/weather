import 'package:dio/dio.dart';

class ApiTokenInterceptor extends Interceptor {
  final String apiToken;

  ApiTokenInterceptor(this.apiToken);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters.addAll({'appid': apiToken});
    handler.next(options);
  }
}

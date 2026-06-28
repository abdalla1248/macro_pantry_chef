import 'package:dio/dio.dart';

import '../config/app_config.dart';

/// Interceptor that appends the `apiKey` query parameter to all outbound Spoonacular requests.
class SpoonacularInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Append the API key to query parameters
    options.queryParameters['apiKey'] = AppConfig.spoonacularApiKey;
    return super.onRequest(options, handler);
  }
}

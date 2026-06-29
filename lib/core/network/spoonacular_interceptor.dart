import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';

/// Interceptor that appends the `apiKey` query parameter to all outbound Spoonacular requests.
///
/// Also validates the API key at request time and logs diagnostic information
/// in debug mode to aid troubleshooting.
class SpoonacularInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = AppConfig.spoonacularApiKey;

    // ── Guard: reject requests if the API key is missing or placeholder ──
    if (apiKey.isEmpty || apiKey == 'PLACEHOLDER_API_KEY') {
      log(
        '⛔ Spoonacular API key is not configured!\n'
        '   Current value: "$apiKey"\n'
        '   Run with: flutter run --dart-define=SPOONACULAR_API_KEY=your_key',
        name: 'SpoonacularInterceptor',
      );
      return handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.cancel,
          message:
              'Spoonacular API key is not configured. '
              'Run with --dart-define=SPOONACULAR_API_KEY=your_key',
        ),
      );
    }

    options.queryParameters['apiKey'] = apiKey;

    // ── Debug logging ──
    if (kDebugMode) {
      log(
        '🌐 Spoonacular Request\n'
        '   Endpoint: ${options.path}\n'
        '   URL: ${options.uri}\n'
        '   Query params: ${options.queryParameters}',
        name: 'SpoonacularInterceptor',
      );
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final data = response.data;
      final resultCount = data is Map ? (data['results'] as List?)?.length : null;
      log(
        '✅ Spoonacular Response\n'
        '   Status: ${response.statusCode}\n'
        '   Results count: ${resultCount ?? "N/A (not a search response)"}',
        name: 'SpoonacularInterceptor',
      );
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '❌ Spoonacular Error\n'
      '   Status: ${err.response?.statusCode}\n'
      '   Message: ${err.message}\n'
      '   Response body: ${err.response?.data}',
      name: 'SpoonacularInterceptor',
    );
    return super.onError(err, handler);
  }
}

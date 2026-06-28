import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exceptions.dart';
import 'spoonacular_interceptor.dart';

/// Singleton Dio HTTP client with interceptors, logging, and error handling.
class DioClient {
  DioClient._();

  static final DioClient _instance = DioClient._();
  static DioClient get instance => _instance;

  late final Dio _dio;

  bool _initialized = false;

  /// Initialise once at app startup.
  void init({
    String baseUrl = '',
    Map<String, dynamic>? headers,
  }) {
    if (_initialized) return;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?headers,
        },
      ),
    );

    _dio.interceptors.add(SpoonacularInterceptor());

    // Logging interceptor (debug only)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    _initialized = true;
  }

  /// Underlying [Dio] instance — use only through typed helpers below.
  Dio get dio {
    assert(_initialized, 'DioClient.init() must be called before use.');
    return _dio;
  }

  // ── Typed Helpers ──────────────────────────────────────────────────

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    }
  }

  // ── Exception Mapper ───────────────────────────────────────────────
  ApiException _mapException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const CancelledException();
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      default:
        return UnknownException(message: e.message ?? 'Unknown error');
    }
  }
}

/// Custom API exception hierarchy for Dio network layer.
sealed class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// Server returned an error response (4xx / 5xx).
class ServerException extends ApiException {
  const ServerException({required super.message, super.statusCode});
}

/// No internet or cannot reach server.
class NetworkException extends ApiException {
  const NetworkException({super.message = 'No internet connection'});
}

/// Request timed out.
class TimeoutException extends ApiException {
  const TimeoutException({super.message = 'Request timed out'});
}

/// Request was cancelled.
class CancelledException extends ApiException {
  const CancelledException({super.message = 'Request cancelled'});
}

/// Unexpected / unknown failure.
class UnknownException extends ApiException {
  const UnknownException({super.message = 'An unexpected error occurred'});
}

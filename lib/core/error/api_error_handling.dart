import 'package:dio/dio.dart';

/// A class to encapsulate detailed information about an API error.
class ErrorDetails {
  final String userMessage;
  final String? debugMessage;
  final int? statusCode;
  final dynamic errorData;

  const ErrorDetails({
    required this.userMessage,
    this.debugMessage,
    this.statusCode,
    this.errorData,
  });

  @override
  String toString() => userMessage;
}

/// Analyzes a [DioException] and returns a structured [ErrorDetails] object.
ErrorDetails handleDioError(DioException e) {
  final statusCode = e.response?.statusCode;
  final errorData = e.response?.data;

  // Extract server message with multiple fallback options
  final serverMessage = _extractServerMessage(errorData);

  // Handle connection-related errors
  if (_isConnectionError(e.type)) {
    return ErrorDetails(
      userMessage: 'No internet connection. Please check your network settings and try again.',
      debugMessage: "DioError: ${e.type} - ${e.message}",
      statusCode: statusCode,
      errorData: errorData,
    );
  }

  // Handle timeout errors
  if (_isTimeoutError(e.type)) {
    return ErrorDetails(
      userMessage: 'Connection timed out. Please try again.',
      debugMessage: "DioError: ${e.type} - ${e.message}",
      statusCode: statusCode,
      errorData: errorData,
    );
  }

  // Handle bad response (server errors)
  if (e.type == DioExceptionType.badResponse) {
    return _handleBadResponse(statusCode, serverMessage, errorData, e);
  }

  // Handle other specific error types
  return _handleOtherErrors(e.type, serverMessage, statusCode, errorData, e);
}

bool _isConnectionError(DioExceptionType type) {
  return type == DioExceptionType.connectionError ||
      type == DioExceptionType.unknown;
}

bool _isTimeoutError(DioExceptionType type) {
  return type == DioExceptionType.connectionTimeout ||
      type == DioExceptionType.sendTimeout ||
      type == DioExceptionType.receiveTimeout;
}

String? _extractServerMessage(dynamic errorData) {
  if (errorData == null) return null;

  if (errorData is Map<String, dynamic>) {
    return errorData['detail']?.toString() ??
        errorData['error']?.toString() ??
        errorData['description']?.toString() ??
        errorData['message']?.toString() ??
        errorData['title']?.toString();
  }

  if (errorData is String &&
      !errorData.contains('<html>') &&
      !errorData.startsWith('/')) {
    return errorData;
  } else if (errorData.toString().contains('<html>') &&
      errorData.startsWith('/')) {
    return null;
  }

  return errorData.toString();
}

ErrorDetails _handleBadResponse(
  int? statusCode,
  String? serverMessage,
  dynamic errorData,
  DioException e,
) {
  if (statusCode != null && statusCode >= 500) {
    return ErrorDetails(
      userMessage: serverMessage ?? 'The server is currently unavailable. Please try again later.',
      debugMessage: "Status: $statusCode - ${e.message} - ServerMsg: $serverMessage",
      statusCode: statusCode,
      errorData: errorData,
    );
  }

  if (serverMessage != null && serverMessage.isNotEmpty) {
    return ErrorDetails(
      userMessage: serverMessage,
      debugMessage: "Status: $statusCode - ${e.message}",
      statusCode: statusCode,
      errorData: errorData,
    );
  }

  final userMessage = _getMessageFromStatusCode(statusCode, serverMessage);

  return ErrorDetails(
    userMessage: userMessage,
    debugMessage: "Status: $statusCode - ${e.message}",
    statusCode: statusCode,
    errorData: errorData,
  );
}

String _getMessageFromStatusCode(int? statusCode, String? serverMessage) {
  if (statusCode == null) {
    return serverMessage ?? 'An unexpected error occurred. Please try again.';
  }

  switch (statusCode) {
    case 400:
      return serverMessage ?? 'Bad request. Please verify the request details and try again.';
    case 401:
      return 'Session expired. Please log in again.';
    case 403:
      return 'Access denied. You do not have permission to access this resource.';
    case 404:
      return 'Resource not found. The requested page or data does not exist.';
    case 408:
      return 'Request timed out. Please try again.';
    case 409:
      return 'Conflict occurred. The resource you are trying to modify already exists or has been modified.';
    case 422:
      return serverMessage ?? 'Validation failed. Please check the entered details and try again.';
    case 429:
      return 'Too many requests. Please wait a moment and try again.';
    default:
      if (statusCode >= 500 && statusCode < 600) {
        return serverMessage ?? 'The server is currently unavailable. Please try again later.';
      } else {
        return serverMessage ?? 'Request failed with status code: $statusCode.';
      }
  }
}

ErrorDetails _handleOtherErrors(
  DioExceptionType type,
  String? serverMessage,
  int? statusCode,
  dynamic errorData,
  DioException e,
) {
  final userMessage = switch (type) {
    DioExceptionType.cancel => 'The request was cancelled.',
    DioExceptionType.badCertificate => 'Secure connection failed due to an invalid security certificate.',
    _ => 'An unexpected error occurred. Please try again.',
  };

  return ErrorDetails(
    userMessage: serverMessage ?? userMessage,
    debugMessage: "DioError: $type - ${e.message}",
    statusCode: statusCode,
    errorData: errorData,
  );
}

String getDioErrorMessage(DioException e) {
  return handleDioError(e).userMessage;
}

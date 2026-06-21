import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// A configured wrapper around the [Dio] HTTP client for making API requests.
///
/// It encapsulates:
/// * Default base configurations (timeouts, headers, base URL).
/// * Authorization interceptor to attach JWT bearer token to headers.
/// * Logging interceptor for formatted requests/responses in debug mode.
class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: Constants.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    _initInterceptors();
  }

  void _initInterceptors() {
    // Logging Interceptor: Prints beautiful console logs in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }
}

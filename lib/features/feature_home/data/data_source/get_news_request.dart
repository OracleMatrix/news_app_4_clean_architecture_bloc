import 'package:dio/dio.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/constants.dart';

class GetNewsRequest {
  final Dio dio;

  GetNewsRequest({required this.dio});

  final apiKey = Constants.apiKey;
  final baseUrl = Constants.baseUrl;

  Future<Response> sendGetNewsRequest(String query) async {
    return await dio.get(
      '$baseUrl/everything',
      queryParameters: {'q': query, 'apikey': apiKey},
    );
  }

  Future<Response> sendGetNewsByFilterRequest({
    required String filterQuery,
    required String searchQuery,
  }) async {
    return await dio.get(
      '$baseUrl/everything',
      queryParameters: {
        'q': searchQuery,
        'sortBy': filterQuery,
        'apikey': apiKey,
      },
    );
  }
}

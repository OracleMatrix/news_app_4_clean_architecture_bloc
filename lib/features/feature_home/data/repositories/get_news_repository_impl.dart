import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/data_source/get_news_request.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/models/get_news_model.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';

class GetNewsRepositoryImpl implements GetNewsRepository {
  final GetNewsRequest getNewsRequest;

  GetNewsRepositoryImpl({required this.getNewsRequest});

  @override
  Future<Either<Failure, GetNewsEntity>> fetchNews(String query) async {
    try {
      final Response response = await getNewsRequest.sendGetNewsRequest(query);
      if (response.statusCode == 200) {
        final GetNewsEntity getNewsEntity = GetNewsModel.fromJson(
          response.data,
        );
        return Right(getNewsEntity);
      } else {
        return Left(ServerFailure(response.data['message'] ?? 'Server error'));
      }
    } on DioException catch (e) {
      return Left(NetworkFailure(e.type.name));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

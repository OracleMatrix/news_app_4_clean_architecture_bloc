import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';

abstract class GetNewsRepository {
  Future<Either<Failure, GetNewsEntity>> fetchNews(String query);
}

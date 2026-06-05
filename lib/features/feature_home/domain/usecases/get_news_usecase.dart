import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';

class GetNewsUseCase implements UseCase<GetNewsEntity, String> {
  final GetNewsRepository getNewsRepository;

  GetNewsUseCase({required this.getNewsRepository});

  @override
  Future<Either<Failure, GetNewsEntity>> call(String query) async {
    return getNewsRepository.fetchNews(query);
  }
}

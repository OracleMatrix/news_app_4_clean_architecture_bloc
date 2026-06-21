import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';

class FilterParams {
  final String filterQuery;
  final String searchQuery;

  FilterParams({required this.filterQuery, required this.searchQuery});
}

class GetNewsByFilterUsecase extends UseCase<GetNewsEntity, FilterParams> {
  final GetNewsRepository repository;

  GetNewsByFilterUsecase({required this.repository});

  @override
  Future<Either<Failure, GetNewsEntity>> call(FilterParams params) {
    return repository.getNewsByFilter(
      filterQuery: params.filterQuery,
      searchQuery: params.searchQuery,
    );
  }
}

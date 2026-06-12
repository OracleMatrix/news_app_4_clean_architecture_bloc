import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/repository/bookmarked_news_repository.dart';

class RemoveBookmarkedNewsUsecase extends UseCase<void, String> {
  final BookmarkedNewsRepository bookmarkedNewsRepository;

  RemoveBookmarkedNewsUsecase({required this.bookmarkedNewsRepository});

  @override
  Future<Either<Failure, void>> call(String params) async {
    return await bookmarkedNewsRepository.removeFromBookmarked(params);
  }
}

import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/repository/bookmarked_news_repository.dart';

class AddNewsToBookmarkUsecase extends UseCase<void, BookMarkedNewsEntity> {
  final BookmarkedNewsRepository bookmarkedNewsRepository;

  AddNewsToBookmarkUsecase({required this.bookmarkedNewsRepository});

  @override
  Future<Either<Failure, void>> call(BookMarkedNewsEntity params) async {
    return await bookmarkedNewsRepository.addToBookmarked(params);
  }
}

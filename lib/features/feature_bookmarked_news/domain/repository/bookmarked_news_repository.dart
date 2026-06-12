import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';

abstract class BookmarkedNewsRepository {
  Future<Either<Failure, List<BookMarkedNewsEntity>>> getBookmarkedNews();
  Future<Either<Failure, void>> addToBookmarked(
    BookMarkedNewsEntity bookmarkedNewsEntity,
  );
  Future<Either<Failure, void>> removeFromBookmarked(String url);
  Future<Either<Failure, bool>> isBookmarked(String url);
}

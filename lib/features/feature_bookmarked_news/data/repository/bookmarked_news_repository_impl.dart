import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/data/data_source/get_bookmarked_news_local_source.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/data/models/bookmarked_news_model.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/repository/bookmarked_news_repository.dart';

class BookmarkedNewsRepositoryImpl implements BookmarkedNewsRepository {
  final GetBookmarkedNewsLocalSource getBookmarkedNewsLocalSource;

  BookmarkedNewsRepositoryImpl({required this.getBookmarkedNewsLocalSource});

  @override
  Future<Either<Failure, void>> addToBookmarked(
    BookMarkedNewsEntity bookmarkedNewsEntity,
  ) async {
    try {
      final model = BookmarkedNewsModel(
        title: bookmarkedNewsEntity.title,
        description: bookmarkedNewsEntity.description,
        content: bookmarkedNewsEntity.content,
        url: bookmarkedNewsEntity.url,
        urlToImage: bookmarkedNewsEntity.urlToImage,
        publishedAt: bookmarkedNewsEntity.publishedAt,
        author: bookmarkedNewsEntity.author,
        sourceName: bookmarkedNewsEntity.sourceName,
      );

      final result = await getBookmarkedNewsLocalSource.addToBookmarked(model);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkedNewsModel>>> getBookmarkedNews() async {
    try {
      final result = await getBookmarkedNewsLocalSource.getBookmarkedNews();
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isBookmarked(String url) async {
    try {
      final result = await getBookmarkedNewsLocalSource.isBookmarked(url);
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromBookmarked(String url) async {
    try {
      final result = await getBookmarkedNewsLocalSource.removeFromBookmarked(
        url,
      );
      return Right(result);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/repository/bookmarked_news_repository.dart';

class CheckIsNewsBookmarkedUsecase extends UseCase<bool, String> {
  final BookmarkedNewsRepository bookmarkedNewsRepository;

  CheckIsNewsBookmarkedUsecase({required this.bookmarkedNewsRepository});

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await bookmarkedNewsRepository.isBookmarked(params);
  }
}

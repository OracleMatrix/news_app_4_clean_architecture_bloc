import 'package:dartz/dartz.dart';
import 'package:share_plus/share_plus.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/repositories/news_details_repository.dart';

class NewsDetailsRepositoryImpl implements NewsDetailsRepository {
  @override
  Future<Either<Failure, void>> shareNews(String url, String title) async {
    try {
      if (url.isEmpty) {
        return const Left(UnknownFailure("Cannot share an empty link"));
      }
      await SharePlus.instance.share(
        ShareParams(text: '$title\n\n$url'),
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

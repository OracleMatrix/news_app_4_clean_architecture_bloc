import 'package:dartz/dartz.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';

abstract class NewsDetailsRepository {
  Future<Either<Failure, void>> shareNews(String url, String title);
}

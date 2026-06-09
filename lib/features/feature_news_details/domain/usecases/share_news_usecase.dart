import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/repositories/news_details_repository.dart';

class ShareNewsUseCase implements UseCase<void, ShareNewsParams> {
  final NewsDetailsRepository repository;

  ShareNewsUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ShareNewsParams params) async {
    return await repository.shareNews(params.url, params.title);
  }
}

class ShareNewsParams extends Equatable {
  final String url;
  final String title;

  const ShareNewsParams({required this.url, required this.title});

  @override
  List<Object?> get props => [url, title];
}

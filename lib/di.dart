import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/data_source/get_news_request.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/repositories/get_news_repository_impl.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/data/repositories/news_details_repository_impl.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/repositories/news_details_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/usecases/share_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/bloc/news_details_bloc.dart';

final GetIt di = GetIt.instance;

Future setup() async {
  di.registerSingleton<GetNewsRequest>(GetNewsRequest(dio: Dio()));

  di.registerSingleton<GetNewsRepository>(
    GetNewsRepositoryImpl(getNewsRequest: di()),
  );

  di.registerSingleton<GetNewsUseCase>(GetNewsUseCase(getNewsRepository: di()));

  di.registerFactory<HomeBloc>(() => HomeBloc(getNewsUseCase: di()));

  // News Details Feature
  di.registerSingleton<NewsDetailsRepository>(NewsDetailsRepositoryImpl());
  di.registerSingleton<ShareNewsUseCase>(ShareNewsUseCase(repository: di()));
  di.registerFactory<NewsDetailsBloc>(() => NewsDetailsBloc(shareNewsUseCase: di()));
}

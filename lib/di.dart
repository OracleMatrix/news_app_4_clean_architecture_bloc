import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/data/data_source/get_bookmarked_news_local_source.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/data/repository/bookmarked_news_repository_impl.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/repository/bookmarked_news_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/add_news_to_bookmark_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/check_is_news_bookmarked_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/get_bookmarked_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/remove_bookmarked_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/presentation/bloc/book_marked_news_bloc.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/data_source/get_news_request.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/repositories/get_news_repository_impl.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_by_filter_usecase.dart';
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

  di.registerFactory<HomeBloc>(() => HomeBloc(getNewsByFilterUsecase: di()));

  di.registerSingleton<GetNewsByFilterUsecase>(
    GetNewsByFilterUsecase(repository: di()),
  );

  // News Details Feature
  di.registerSingleton<NewsDetailsRepository>(NewsDetailsRepositoryImpl());
  di.registerSingleton<ShareNewsUseCase>(ShareNewsUseCase(repository: di()));
  di.registerFactory<NewsDetailsBloc>(
    () => NewsDetailsBloc(shareNewsUseCase: di()),
  );

  // Bookmarked News Feature
  di.registerSingleton<GetBookmarkedNewsLocalSource>(
    GetBookmarkedNewsLocalSourceImpl(),
  );
  di.registerSingleton<BookmarkedNewsRepository>(
    BookmarkedNewsRepositoryImpl(getBookmarkedNewsLocalSource: di()),
  );
  di.registerSingleton<GetBookmarkedNewsUsecase>(
    GetBookmarkedNewsUsecase(bookmarkedNewsRepository: di()),
  );
  di.registerSingleton<AddNewsToBookmarkUsecase>(
    AddNewsToBookmarkUsecase(bookmarkedNewsRepository: di()),
  );
  di.registerSingleton<RemoveBookmarkedNewsUsecase>(
    RemoveBookmarkedNewsUsecase(bookmarkedNewsRepository: di()),
  );
  di.registerSingleton<CheckIsNewsBookmarkedUsecase>(
    CheckIsNewsBookmarkedUsecase(bookmarkedNewsRepository: di()),
  );
  di.registerFactory<BookMarkedNewsBloc>(
    () => BookMarkedNewsBloc(
      getBookmarkedNewsUsecase: di(),
      addNewsToBookmarkUsecase: di(),
      removeBookmarkedNewsUsecase: di(),
      isNewsBookmarkedUsecase: di(),
    ),
  );
}

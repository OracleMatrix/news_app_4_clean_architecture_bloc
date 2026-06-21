import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/repositories/news_details_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/usecases/share_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/presentation/bloc/news_details_bloc.dart';

class StubNewsDetailsRepository implements NewsDetailsRepository {
  Either<Failure, void>? result;

  @override
  Future<Either<Failure, void>> shareNews(String url, String title) async {
    return result!;
  }
}

void main() {
  late ShareNewsUseCase shareNewsUseCase;
  late StubNewsDetailsRepository stubRepository;
  late NewsDetailsBloc newsDetailsBloc;

  setUp(() {
    stubRepository = StubNewsDetailsRepository();
    shareNewsUseCase = ShareNewsUseCase(repository: stubRepository);
    newsDetailsBloc = NewsDetailsBloc(shareNewsUseCase: shareNewsUseCase);
  });

  tearDown(() {
    newsDetailsBloc.close();
  });

  test('initial state should be ShareStatus.initial', () {
    expect(newsDetailsBloc.state.shareStatus, ShareStatus.initial);
  });

  blocTest<NewsDetailsBloc, NewsDetailsState>(
    'should emit [ShareStatus.loading, ShareStatus.success] when shareNews is successful',
    build: () {
      stubRepository.result = const Right(null);
      return newsDetailsBloc;
    },
    act: (bloc) => bloc.add(const ShareArticleEvent(url: 'url', title: 'title')),
    expect: () => [
      const NewsDetailsState(shareStatus: ShareStatus.loading),
      const NewsDetailsState(shareStatus: ShareStatus.success),
    ],
  );

  blocTest<NewsDetailsBloc, NewsDetailsState>(
    'should emit [ShareStatus.loading, ShareStatus.error] when shareNews fails',
    build: () {
      stubRepository.result = const Left(UnknownFailure('error'));
      return newsDetailsBloc;
    },
    act: (bloc) => bloc.add(const ShareArticleEvent(url: 'url', title: 'title')),
    expect: () => [
      const NewsDetailsState(shareStatus: ShareStatus.loading),
      const NewsDetailsState(shareStatus: ShareStatus.error, errorMessage: 'error'),
    ],
  );
}

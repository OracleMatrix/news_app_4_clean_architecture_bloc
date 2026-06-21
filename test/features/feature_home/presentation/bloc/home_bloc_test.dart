import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_by_filter_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

class MockGetNewsByFilterUsecase extends Mock implements GetNewsByFilterUsecase {
  @override
  Future<Either<Failure, GetNewsEntity>> call(FilterParams? params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future.value(
          const Right<Failure, GetNewsEntity>(GetNewsEntity()),
        ),
        returnValueForMissingStub: Future.value(
          const Right<Failure, GetNewsEntity>(GetNewsEntity()),
        ),
      );
}

void main() {
  late HomeBloc homeBloc;
  late MockGetNewsByFilterUsecase mockGetNewsByFilterUsecase;

  setUp(() {
    mockGetNewsByFilterUsecase = MockGetNewsByFilterUsecase();
    homeBloc = HomeBloc(getNewsByFilterUsecase: mockGetNewsByFilterUsecase);
  });

  tearDown(() {
    homeBloc.close();
  });

  const tQuery = 'flutter';
  const tNewsEntity = GetNewsEntity(
    status: 'ok',
    totalResults: 0,
    articles: [],
  );

  group('HomeBloc', () {
    test('initial state should be GetNewsStatus.loading', () {
      expect(homeBloc.state.getNewsStatus, GetNewsStatus.loading);
      expect(homeBloc.state.selectedCategory, Category.technology);
      expect(homeBloc.state.selectedFilter, FilterNewsStatus.popularity);
    });

    blocTest<HomeBloc, HomeState>(
      'should emit [GetNewsStatus.completed] when success',
      build: () {
        when(
          mockGetNewsByFilterUsecase(any),
        ).thenAnswer((_) async => const Right(tNewsEntity));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadNewsEvent(query: tQuery, filterNewsStatus: FilterNewsStatus.popularity)),
      expect: () => [
        const HomeState(
          getNewsStatus: GetNewsStatus.loading,
          selectedCategory: Category.technology,
          selectedFilter: FilterNewsStatus.popularity,
        ),
        const HomeState(
          getNewsStatus: GetNewsStatus.completed,
          getNewsEntity: tNewsEntity,
          selectedCategory: Category.technology,
          selectedFilter: FilterNewsStatus.popularity,
        ),
      ],
      verify: (_) {
        verify(mockGetNewsByFilterUsecase(any));
      },
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [GetNewsStatus.error] when failure',
      build: () {
        when(
          mockGetNewsByFilterUsecase(any),
        ).thenAnswer((_) async => const Left(ServerFailure('error')));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadNewsEvent(query: tQuery, filterNewsStatus: FilterNewsStatus.popularity)),
      expect: () => [
        const HomeState(
          getNewsStatus: GetNewsStatus.loading,
          selectedCategory: Category.technology,
          selectedFilter: FilterNewsStatus.popularity,
        ),
        const HomeState(
          getNewsStatus: GetNewsStatus.error,
          errorMessage: 'error',
          selectedCategory: Category.technology,
          selectedFilter: FilterNewsStatus.popularity,
        ),
      ],
    );
  });
}

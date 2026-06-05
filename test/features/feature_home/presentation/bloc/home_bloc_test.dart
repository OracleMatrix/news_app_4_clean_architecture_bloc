import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/presentation/bloc/home_bloc.dart';

class MockGetNewsUseCase extends Mock implements GetNewsUseCase {
  @override
  Future<Either<Failure, GetNewsEntity>> call(String? params) =>
      super.noSuchMethod(
        Invocation.method(#call, [params]),
        returnValue: Future.value(
          const Right<Failure, GetNewsEntity>(GetNewsEntity()),
        ),
      );
}

void main() {
  late HomeBloc homeBloc;
  late MockGetNewsUseCase mockGetNewsUseCase;

  setUp(() {
    mockGetNewsUseCase = MockGetNewsUseCase();
    homeBloc = HomeBloc(getNewsUseCase: mockGetNewsUseCase);
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
    test('initial state should be LoadingNewsStatus', () {
      expect(homeBloc.state.getNewsStatus, isA<LoadingNewsStatus>());
    });

    blocTest<HomeBloc, HomeState>(
      'should emit [GetNewsCompletedStatus] when success',
      build: () {
        when(
          mockGetNewsUseCase(any),
        ).thenAnswer((_) async => const Right(tNewsEntity));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadNewsEvent(tQuery)),
      expect: () => [
        HomeState(getNewsStatus: LoadingNewsStatus()),
        HomeState(getNewsStatus: GetNewsCompletedStatus(tNewsEntity)),
      ],
      verify: (_) {
        verify(mockGetNewsUseCase(tQuery));
      },
    );

    blocTest<HomeBloc, HomeState>(
      'should emit [ErrorOnGettingNewsStatus] when failure',
      build: () {
        when(
          mockGetNewsUseCase(any),
        ).thenAnswer((_) async => const Left(ServerFailure('error')));
        return homeBloc;
      },
      act: (bloc) => bloc.add(LoadNewsEvent(tQuery)),
      expect: () => [
        HomeState(getNewsStatus: LoadingNewsStatus()),
        HomeState(getNewsStatus: ErrorOnGettingNewsStatus('error')),
      ],
    );
  });
}

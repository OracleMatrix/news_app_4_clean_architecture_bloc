import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/repositories/get_news_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_usecase.dart';

class MockGetNewsRepository extends Mock implements GetNewsRepository {
  @override
  Future<Either<Failure, GetNewsEntity>> fetchNews(String? query) =>
      super.noSuchMethod(
        Invocation.method(#fetchNews, [query]),
        returnValue: Future.value(
          const Right<Failure, GetNewsEntity>(GetNewsEntity()),
        ),
        returnValueForMissingStub: Future.value(
          const Right<Failure, GetNewsEntity>(GetNewsEntity()),
        ),
      );
}

void main() {
  late GetNewsUseCase useCase;
  late MockGetNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockGetNewsRepository();
    useCase = GetNewsUseCase(getNewsRepository: mockRepository);
  });

  const tQuery = 'flutter';
  const tNewsEntity = GetNewsEntity(
    status: 'ok',
    totalResults: 1,
    articles: [
      ArticleEntity(title: 'Test Title', description: 'Test Description'),
    ],
  );

  const tFailure = ServerFailure('Server error');

  group('GetNewsUseCase', () {
    test('should get news from the repository when successful', () async {
      // arrange
      when(
        mockRepository.fetchNews(any),
      ).thenAnswer((_) async => const Right(tNewsEntity));

      // act
      final result = await useCase(tQuery);

      // assert
      expect(result, const Right(tNewsEntity));
      verify(mockRepository.fetchNews(tQuery));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
      'should return failure from the repository when unsuccessful',
      () async {
        // arrange
        when(
          mockRepository.fetchNews(any),
        ).thenAnswer((_) async => const Left(tFailure));

        // act
        final result = await useCase(tQuery);

        // assert
        expect(result, const Left(tFailure));
        verify(mockRepository.fetchNews(tQuery));
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}

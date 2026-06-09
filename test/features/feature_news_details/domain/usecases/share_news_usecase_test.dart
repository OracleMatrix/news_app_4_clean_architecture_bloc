import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/repositories/news_details_repository.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/usecases/share_news_usecase.dart';

class MockNewsDetailsRepository extends Mock implements NewsDetailsRepository {
  @override
  Future<Either<Failure, void>> shareNews(String? url, String? title) =>
      super.noSuchMethod(
        Invocation.method(#shareNews, [url, title]),
        returnValue: Future.value(const Right<Failure, void>(null)),
        returnValueForMissingStub:
            Future.value(const Right<Failure, void>(null)),
      );
}

void main() {
  late ShareNewsUseCase useCase;
  late MockNewsDetailsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsDetailsRepository();
    useCase = ShareNewsUseCase(repository: mockRepository);
  });

  const tParams = ShareNewsParams(url: 'https://test.com', title: 'Test Title');
  const tFailure = UnknownFailure('Share error');

  group('ShareNewsUseCase', () {
    test('should execute shareNews from the repository when successful', () async {
      // arrange
      when(mockRepository.shareNews(any, any))
          .thenAnswer((_) async => const Right(null));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Right(null));
      verify(mockRepository.shareNews(tParams.url, tParams.title));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure from the repository when unsuccessful', () async {
      // arrange
      when(mockRepository.shareNews(any, any))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await useCase(tParams);

      // assert
      expect(result, const Left(tFailure));
      verify(mockRepository.shareNews(tParams.url, tParams.title));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}

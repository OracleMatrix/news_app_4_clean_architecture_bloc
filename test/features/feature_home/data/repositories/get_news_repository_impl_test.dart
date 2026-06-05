import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/data_source/get_news_request.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/repositories/get_news_repository_impl.dart';

class MockGetNewsRequest extends Mock implements GetNewsRequest {
  @override
  Future<Response> sendGetNewsRequest(String? query) => super.noSuchMethod(
    Invocation.method(#sendGetNewsRequest, [query]),
    returnValue: Future.value(
      Response(
        requestOptions: RequestOptions(path: ''),
        data: {'status': 'ok'},
        statusCode: 200,
      ),
    ),
  );
}

void main() {
  late GetNewsRepositoryImpl repository;
  late MockGetNewsRequest mockGetNewsRequest;

  setUp(() {
    mockGetNewsRequest = MockGetNewsRequest();
    repository = GetNewsRepositoryImpl(getNewsRequest: mockGetNewsRequest);
  });

  group('GetNewsRepositoryImpl', () {
    const tQuery = 'flutter';
    const tNewsJson = {
      'status': 'ok',
      'totalResults': 1,
      'articles': [
        {
          'source': {'id': '1', 'name': 'Source'},
          'author': 'Author',
          'title': 'Title',
          'description': 'Description',
          'url': 'url',
          'urlToImage': 'image',
          'publishedAt': 'date',
          'content': 'content',
        },
      ],
    };

    test('should return GetNewsEntity when the response is 200', () async {
      // arrange
      when(mockGetNewsRequest.sendGetNewsRequest(any)).thenAnswer(
        (_) async => Response(
          data: tNewsJson,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await repository.fetchNews(tQuery);

      // assert
      expect(result.isRight(), true);
      verify(mockGetNewsRequest.sendGetNewsRequest(tQuery));
    });

    test('should return ServerFailure when the response is not 200', () async {
      // arrange
      when(mockGetNewsRequest.sendGetNewsRequest(any)).thenAnswer(
        (_) async => Response(
          data: {'message': 'Error'},
          statusCode: 404,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      // act
      final result = await repository.fetchNews(tQuery);

      // assert
      expect(result, const Left(ServerFailure('Error')));
      verify(mockGetNewsRequest.sendGetNewsRequest(tQuery));
    });

    test('should return NetworkFailure when DioException occurs', () async {
      // arrange
      when(mockGetNewsRequest.sendGetNewsRequest(any)).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      // act
      final result = await repository.fetchNews(tQuery);

      // assert
      expect(result, const Left(NetworkFailure('connectionTimeout')));
    });

    test(
      'should return UnknownFailure when any other exception occurs',
      () async {
        // arrange
        when(
          mockGetNewsRequest.sendGetNewsRequest(any),
        ).thenThrow(Exception('test'));

        // act
        final result = await repository.fetchNews(tQuery);

        // assert
        expect(result, const Left(UnknownFailure('Exception: test')));
      },
    );
  });
}

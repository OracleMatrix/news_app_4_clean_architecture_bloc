import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/constants.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/data_source/get_news_request.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) => super.noSuchMethod(
    Invocation.method(
      #get,
      [path],
      {
        #data: data,
        #queryParameters: queryParameters,
        #options: options,
        #cancelToken: cancelToken,
        #onReceiveProgress: onReceiveProgress,
      },
    ),
    returnValue: Future.value(
      Response<T>(
        requestOptions: RequestOptions(path: path),
        data: null,
        statusCode: 200,
      ),
    ),
  );
}

void main() {
  late GetNewsRequest dataSource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    dataSource = GetNewsRequest(dio: mockDio);
  });

  group('GetNewsRequest', () {
    const tQuery = 'flutter';
    final tResponse = Response(
      data: {'status': 'ok'},
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

    test(
      'should perform a GET request on /everything with query and apikey',
      () async {
        // arrange
        when(
          mockDio.get<dynamic>(
            '${Constants.baseUrl}/everything',
            queryParameters: anyNamed('queryParameters'),
          ),
        ).thenAnswer((_) async => tResponse);

        // act
        await dataSource.sendGetNewsRequest(tQuery);

        // assert
        verify(
          mockDio.get(
            '${Constants.baseUrl}/everything',
            queryParameters: {'q': tQuery, 'apikey': Constants.apiKey},
          ),
        );
      },
    );
  });
}

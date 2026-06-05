import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/data/models/get_news_model.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';

void main() {
  const tSourceModel = SourceModel(id: '1', name: 'Source');
  const tArticleModel = ArticleModel(
    source: tSourceModel,
    author: 'Author',
    title: 'Title',
    description: 'Description',
    url: 'url',
    urlToImage: 'image',
    publishedAt: 'date',
    content: 'content',
  );
  const tGetNewsModel = GetNewsModel(
    status: 'ok',
    totalResults: 1,
    articles: [tArticleModel],
  );

  final Map<String, dynamic> tJson = {
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

  group('GetNewsModel', () {
    test('should be a subclass of GetNewsEntity', () {
      expect(tGetNewsModel, isA<GetNewsEntity>());
    });

    test('fromJson should return a valid model', () {
      // act
      final result = GetNewsModel.fromJson(tJson);

      // assert
      expect(result, tGetNewsModel);
    });

    test('toJson should return a JSON map containing proper data', () {
      // act
      final result = tGetNewsModel.toJson();

      // assert
      expect(result, tJson);
    });
  });

  group('ArticleModel', () {
    test('fromJson should return a valid model', () {
      final json = (tJson['articles'] as List)[0] as Map<String, dynamic>;
      final result = ArticleModel.fromJson(json);
      expect(result, tArticleModel);
    });
  });

  group('SourceModel', () {
    test('fromJson should return a valid model', () {
      final json =
          ((tJson['articles'] as List)[0] as Map<String, dynamic>)['source']
              as Map<String, dynamic>;
      final result = SourceModel.fromJson(json);
      expect(result, tSourceModel);
    });
  });
}

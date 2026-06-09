import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/entities/news_detail_entity.dart';

void main() {
  group('NewsDetailEntity', () {
    test('should support value equality', () {
      const entity1 = NewsDetailEntity(
        title: 'Title',
        description: 'Description',
        content: 'Content',
        url: 'url',
        urlToImage: 'urlToImage',
        publishedAt: '2026-06-09',
        author: 'Author',
        sourceName: 'Source',
      );
      const entity2 = NewsDetailEntity(
        title: 'Title',
        description: 'Description',
        content: 'Content',
        url: 'url',
        urlToImage: 'urlToImage',
        publishedAt: '2026-06-09',
        author: 'Author',
        sourceName: 'Source',
      );

      expect(entity1, entity2);
    });

    test('should construct from ArticleEntity correctly', () {
      const article = ArticleEntity(
        title: 'Test Title',
        description: 'Test Description',
        content: 'Test Content',
        url: 'https://test.com',
        urlToImage: 'https://test.com/image.png',
        publishedAt: '2026-06-09T00:00:00Z',
        author: 'Test Author',
        source: SourceEntity(id: '1', name: 'Test Source'),
      );

      final entity = NewsDetailEntity.fromArticleEntity(article);

      expect(entity.title, 'Test Title');
      expect(entity.description, 'Test Description');
      expect(entity.content, 'Test Content');
      expect(entity.url, 'https://test.com');
      expect(entity.urlToImage, 'https://test.com/image.png');
      expect(entity.publishedAt, '2026-06-09T00:00:00Z');
      expect(entity.author, 'Test Author');
      expect(entity.sourceName, 'Test Source');
    });

    test('should fallback to defaults when ArticleEntity properties are null', () {
      const article = ArticleEntity(
        title: null,
        description: null,
        content: null,
        url: null,
        urlToImage: null,
        publishedAt: null,
        author: null,
        source: null,
      );

      final entity = NewsDetailEntity.fromArticleEntity(article);

      expect(entity.title, 'No Title');
      expect(entity.description, 'No Description available');
      expect(entity.content, 'No Content available');
      expect(entity.url, '');
      expect(entity.urlToImage, '');
      expect(entity.publishedAt, '');
      expect(entity.author, 'Unknown Author');
      expect(entity.sourceName, 'News');
    });
  });
}

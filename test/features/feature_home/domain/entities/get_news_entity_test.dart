import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';

void main() {
  group('Entities Equality', () {
    test('SourceEntity should support value equality', () {
      expect(
        const SourceEntity(id: '1', name: 'Source'),
        const SourceEntity(id: '1', name: 'Source'),
      );
    });

    test('ArticleEntity should support value equality', () {
      expect(
        const ArticleEntity(title: 'Title'),
        const ArticleEntity(title: 'Title'),
      );
    });

    test('GetNewsEntity should support value equality', () {
      expect(
        const GetNewsEntity(status: 'ok', totalResults: 1),
        const GetNewsEntity(status: 'ok', totalResults: 1),
      );
    });
  });
}

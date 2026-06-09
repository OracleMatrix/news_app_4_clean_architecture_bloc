import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app_4_clean_architecture_bloc/core/error/failure.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/data/repositories/news_details_repository_impl.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

class FakeSharePlatform extends SharePlatform {
  ShareParams? sharedParams;
  bool shouldThrow = false;

  @override
  Future<ShareResult> share(ShareParams params) async {
    if (shouldThrow) {
      throw Exception('Share failed');
    }
    sharedParams = params;
    return const ShareResult('success', ShareResultStatus.success);
  }
}

// Single persistent instance for the entire test file
final fakePlatform = FakeSharePlatform();

void main() {
  late NewsDetailsRepositoryImpl repository;

  setUpAll(() {
    SharePlatform.instance = fakePlatform;
  });

  setUp(() {
    // Reset properties before each test
    fakePlatform.sharedParams = null;
    fakePlatform.shouldThrow = false;
    repository = NewsDetailsRepositoryImpl();
  });

  group('NewsDetailsRepositoryImpl', () {
    const tUrl = 'https://test.com';
    const tTitle = 'Test Title';

    test('should invoke SharePlus share with formatted text', () async {
      // act
      final result = await repository.shareNews(tUrl, tTitle);

      // assert
      expect(result, const Right(null));
      expect(fakePlatform.sharedParams, isNotNull);
      expect(fakePlatform.sharedParams!.text, '$tTitle\n\n$tUrl');
    });

    test('should return UnknownFailure when url is empty', () async {
      // act
      final result = await repository.shareNews('', tTitle);

      // assert
      expect(result, const Left(UnknownFailure('Cannot share an empty link')));
      expect(fakePlatform.sharedParams, isNull);
    });

    test('should return UnknownFailure when platform throws exception', () async {
      // arrange
      fakePlatform.shouldThrow = true;

      // act
      final result = await repository.shareNews(tUrl, tTitle);

      // assert
      expect(result, const Left(UnknownFailure('Exception: Share failed')));
    });
  });
}

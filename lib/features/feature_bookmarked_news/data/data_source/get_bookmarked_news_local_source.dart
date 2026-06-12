import 'package:get_storage/get_storage.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/constants.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/data/models/bookmarked_news_model.dart';

abstract class GetBookmarkedNewsLocalSource {
  Future<List<BookmarkedNewsModel>> getBookmarkedNews();
  Future<void> addToBookmarked(BookmarkedNewsModel bookmarkedNewsModel);
  Future<void> removeFromBookmarked(String url);
  Future<bool> isBookmarked(String url);
}

class GetBookmarkedNewsLocalSourceImpl implements GetBookmarkedNewsLocalSource {
  final getBookmarkedNewsBox = GetStorage();
  final String boxKey = Constants.getBookmarkedNewsKey;

  @override
  Future<List<BookmarkedNewsModel>> getBookmarkedNews() async {
    final List<dynamic>? rawData = getBookmarkedNewsBox.read<List<dynamic>>(
      boxKey,
    );
    if (rawData == null) return [];

    return rawData
        .map((e) => BookmarkedNewsModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> addToBookmarked(BookmarkedNewsModel bookmarkedNewsModel) async {
    final List<BookmarkedNewsModel> currentList = await getBookmarkedNews();

    final isExist = currentList.any(
      (element) => element.url == bookmarkedNewsModel.url,
    );
    if (!isExist) {
      currentList.add(bookmarkedNewsModel);
      final List<Map<String, dynamic>> jsonList = currentList
          .map((e) => e.toMap())
          .toList();
      await getBookmarkedNewsBox.write(boxKey, jsonList);
    }
  }

  @override
  Future<void> removeFromBookmarked(String url) async {
    final List<BookmarkedNewsModel> currentList = await getBookmarkedNews();
    currentList.removeWhere((element) => element.url == url);

    final List<Map<String, dynamic>> jsonList = currentList
        .map((e) => e.toMap())
        .toList();
    await getBookmarkedNewsBox.write(boxKey, jsonList);
  }

  @override
  Future<bool> isBookmarked(String url) async {
    final List<BookmarkedNewsModel> bookMarkedNewsData =
        await getBookmarkedNews();
    return bookMarkedNewsData.any((element) => element.url == url);
  }
}

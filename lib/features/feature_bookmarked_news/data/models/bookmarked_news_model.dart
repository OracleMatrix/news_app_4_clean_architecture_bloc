import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';

class BookmarkedNewsModel extends BookMarkedNewsEntity {
  const BookmarkedNewsModel({
    required super.title,
    required super.description,
    required super.content,
    required super.url,
    required super.urlToImage,
    required super.publishedAt,
    required super.author,
    required super.sourceName,
  });

  factory BookmarkedNewsModel.fromMap(Map<String, dynamic> map) {
    return BookmarkedNewsModel(
      title: map['title'],
      description: map['description'],
      content: map['content'],
      url: map['url'],
      urlToImage: map['urlToImage'],
      publishedAt: map['publishedAt'],
      author: map['author'],
      sourceName: map['sourceName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'author': author,
      'sourceName': sourceName,
    };
  }
}

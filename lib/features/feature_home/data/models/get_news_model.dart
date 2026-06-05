import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';

class GetNewsModel extends GetNewsEntity {
  const GetNewsModel({super.status, super.totalResults, super.articles});

  factory GetNewsModel.fromJson(Map<String, dynamic> json) {
    return GetNewsModel(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: (json['articles'] as List?)
          ?.map((e) => ArticleModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles?.map((e) => (e as ArticleModel).toJson()).toList(),
    };
  }
}

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    super.source,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: json['source'] != null
          ? SourceModel.fromJson(json['source'])
          : null,
      author: json['author'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': (source as SourceModel?)?.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}

class SourceModel extends SourceEntity {
  const SourceModel({super.id, super.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

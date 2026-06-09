import 'package:equatable/equatable.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';

class NewsDetailEntity extends Equatable {
  final String title;
  final String description;
  final String content;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String author;
  final String sourceName;

  const NewsDetailEntity({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.author,
    required this.sourceName,
  });

  factory NewsDetailEntity.fromArticleEntity(ArticleEntity article) {
    return NewsDetailEntity(
      title: article.title ?? 'No Title',
      description: article.description ?? 'No Description available',
      content: article.content ?? 'No Content available',
      url: article.url ?? '',
      urlToImage: article.urlToImage ?? '',
      publishedAt: article.publishedAt ?? '',
      author: article.author ?? 'Unknown Author',
      sourceName: article.source?.name ?? 'News',
    );
  }

  @override
  List<Object?> get props => [
        title,
        description,
        content,
        url,
        urlToImage,
        publishedAt,
        author,
        sourceName,
      ];
}

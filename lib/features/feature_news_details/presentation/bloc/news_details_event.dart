part of 'news_details_bloc.dart';

abstract class NewsDetailsEvent extends Equatable {
  const NewsDetailsEvent();

  @override
  List<Object?> get props => [];
}

class ShareArticleEvent extends NewsDetailsEvent {
  final String url;
  final String title;

  const ShareArticleEvent({required this.url, required this.title});

  @override
  List<Object?> get props => [url, title];
}

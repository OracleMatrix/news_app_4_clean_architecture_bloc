part of 'book_marked_news_bloc.dart';

sealed class BookMarkedNewsEvent extends Equatable {
  const BookMarkedNewsEvent();

  @override
  List<Object> get props => [];
}

class FetchBookmarkedNewsEvent extends BookMarkedNewsEvent {
  @override
  List<Object> get props => [];
}

class RemoveBookmarkedNewsEvent extends BookMarkedNewsEvent {
  final String url;

  const RemoveBookmarkedNewsEvent({required this.url});

  @override
  List<Object> get props => [url];
}

class CheckIsNewsBookmarkedEvent extends BookMarkedNewsEvent {
  final String url;

  const CheckIsNewsBookmarkedEvent({required this.url});

  @override
  List<Object> get props => [url];
}

class AddBookmarkedNewsEvent extends BookMarkedNewsEvent {
  final BookMarkedNewsEntity bookMarkedNewsEntity;

  const AddBookmarkedNewsEvent({required this.bookMarkedNewsEntity});

  @override
  List<Object> get props => [bookMarkedNewsEntity];
}

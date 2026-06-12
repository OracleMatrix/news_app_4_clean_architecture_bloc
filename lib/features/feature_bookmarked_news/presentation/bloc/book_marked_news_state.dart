part of 'book_marked_news_bloc.dart';

enum BookMarkNewsStatus { error, loading, loaded, initial, empty }

class BookMarkedNewsState extends Equatable {
  final BookMarkNewsStatus status;
  final BookMarkNewsStatus? submitRequest;
  final String? errorMessage;
  final List<BookMarkedNewsEntity>? bookmarkedNewsData;
  final bool? isBookmarked;

  const BookMarkedNewsState({
    required this.status,
    this.errorMessage,
    this.bookmarkedNewsData,
    this.submitRequest,
    this.isBookmarked,
  });

  BookMarkedNewsState copyWith({
    BookMarkNewsStatus? status,
    String? errorMessage,
    List<BookMarkedNewsEntity>? bookmarkedNewsData,
    BookMarkNewsStatus? submitRequest,
    bool? isBookmarked,
  }) {
    return BookMarkedNewsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      bookmarkedNewsData: bookmarkedNewsData ?? this.bookmarkedNewsData,
      submitRequest: submitRequest ?? this.submitRequest,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object> get props => [
    status,
    ?errorMessage,
    ?bookmarkedNewsData,
    ?submitRequest,
    ?isBookmarked,
  ];
}

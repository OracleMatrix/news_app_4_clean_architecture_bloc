import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_4_clean_architecture_bloc/core/utils/usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/entity/bookmarked_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/add_news_to_bookmark_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/check_is_news_bookmarked_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/get_bookmarked_news_usecase.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_bookmarked_news/domain/usecases/remove_bookmarked_news_usecase.dart';

part 'book_marked_news_event.dart';
part 'book_marked_news_state.dart';

class BookMarkedNewsBloc
    extends Bloc<BookMarkedNewsEvent, BookMarkedNewsState> {
  final GetBookmarkedNewsUsecase getBookmarkedNewsUsecase;
  final AddNewsToBookmarkUsecase addNewsToBookmarkUsecase;
  final RemoveBookmarkedNewsUsecase removeBookmarkedNewsUsecase;
  final CheckIsNewsBookmarkedUsecase isNewsBookmarkedUsecase;

  BookMarkedNewsBloc({
    required this.getBookmarkedNewsUsecase,
    required this.addNewsToBookmarkUsecase,
    required this.removeBookmarkedNewsUsecase,
    required this.isNewsBookmarkedUsecase,
  }) : super(const BookMarkedNewsState(status: BookMarkNewsStatus.initial)) {
    on<FetchBookmarkedNewsEvent>(_onFetchBookmarkedNews);
    on<AddBookmarkedNewsEvent>(_onAddBookmarkedNews);
    on<RemoveBookmarkedNewsEvent>(_onRemoveBookmarkedNews);
    on<CheckIsNewsBookmarkedEvent>(_onCheckIsNewsBookmarked);
  }

  Future<void> _onFetchBookmarkedNews(
    FetchBookmarkedNewsEvent event,
    Emitter<BookMarkedNewsState> emit,
  ) async {
    emit(state.copyWith(status: BookMarkNewsStatus.loading));
    final result = await getBookmarkedNewsUsecase(NoParam());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BookMarkNewsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (bookmarkedNewsData) {
        if (bookmarkedNewsData.isEmpty) {
          emit(state.copyWith(status: BookMarkNewsStatus.empty));
        } else {
          emit(
            state.copyWith(
              status: BookMarkNewsStatus.loaded,
              bookmarkedNewsData: bookmarkedNewsData,
            ),
          );
        }
      },
    );
  }

  Future<void> _onAddBookmarkedNews(
    AddBookmarkedNewsEvent event,
    Emitter<BookMarkedNewsState> emit,
  ) async {
    emit(
      state.copyWith(
        submitRequest: BookMarkNewsStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await addNewsToBookmarkUsecase(event.bookMarkedNewsEntity);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.loaded,
          isBookmarked: true,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onRemoveBookmarkedNews(
    RemoveBookmarkedNewsEvent event,
    Emitter<BookMarkedNewsState> emit,
  ) async {
    emit(
      state.copyWith(
        submitRequest: BookMarkNewsStatus.loading,
        errorMessage: null,
      ),
    );

    List<BookMarkedNewsEntity>? updateList;
    if (state.bookmarkedNewsData != null) {
      updateList = List<BookMarkedNewsEntity>.from(
        state.bookmarkedNewsData!,
      )..removeWhere((element) => element.url == event.url);
    }

    emit(
      state.copyWith(
        bookmarkedNewsData: updateList,
        status: (updateList?.isEmpty ?? false) ? BookMarkNewsStatus.empty : state.status,
      ),
    );

    final result = await removeBookmarkedNewsUsecase(event.url);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.loaded,
          isBookmarked: false,
          errorMessage: null,
        ),
      ),
    );
  }

  Future<void> _onCheckIsNewsBookmarked(
    CheckIsNewsBookmarkedEvent event,
    Emitter<BookMarkedNewsState> emit,
  ) async {
    emit(state.copyWith(submitRequest: BookMarkNewsStatus.loading));
    final result = await isNewsBookmarkedUsecase(event.url);
    result.fold(
      (failure) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (isBookmarked) => emit(
        state.copyWith(
          submitRequest: BookMarkNewsStatus.loaded,
          isBookmarked: isBookmarked,
        ),
      ),
    );
  }
}

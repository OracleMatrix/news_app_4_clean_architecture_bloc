import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_news_details/domain/usecases/share_news_usecase.dart';

part 'news_details_event.dart';
part 'news_details_state.dart';

class NewsDetailsBloc extends Bloc<NewsDetailsEvent, NewsDetailsState> {
  final ShareNewsUseCase shareNewsUseCase;

  NewsDetailsBloc({required this.shareNewsUseCase})
      : super(NewsDetailsState(shareStatus: ShareInitialStatus())) {
    on<ShareArticleEvent>(_onShareArticle);
  }

  Future<void> _onShareArticle(
      ShareArticleEvent event, Emitter<NewsDetailsState> emit) async {
    emit(state.copyWith(shareStatus: ShareLoadingStatus()));

    final result = await shareNewsUseCase(
      ShareNewsParams(url: event.url, title: event.title),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(shareStatus: ShareErrorStatus(failure.message)),
      ),
      (_) => emit(state.copyWith(shareStatus: ShareSuccessStatus())),
    );
  }
}

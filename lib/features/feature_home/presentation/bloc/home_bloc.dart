import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_by_filter_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNewsByFilterUsecase getNewsByFilterUsecase;

  HomeBloc({required this.getNewsByFilterUsecase})
    : super(
        HomeState(
          getNewsStatus: LoadingNewsStatus(),
          selectedCategory: Category.technology,
          selectedFilter: FilterNewsStatus.popularity,
        ),
      ) {
    on<LoadNewsEvent>(_loadNews);
    on<ChangeCategoryEvent>(_changeCategory);
    on<FilterNewsEvent>(_filterNews);
  }

  Future<void> _loadNews(LoadNewsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(getNewsStatus: LoadingNewsStatus()));

    final result = await getNewsByFilterUsecase(
      FilterParams(
        filterQuery: event.filterNewsStatus.name,
        searchQuery: event.query,
      ),
    );

    result.fold(
      (l) => emit(
        state.copyWith(getNewsStatus: ErrorOnGettingNewsStatus(l.message)),
      ),
      (r) => emit(state.copyWith(getNewsStatus: GetNewsCompletedStatus(r))),
    );
  }

  Future<void> _changeCategory(
    ChangeCategoryEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      state.copyWith(
        getNewsStatus: LoadingNewsStatus(),
        selectedCategory: event.category,
      ),
    );

    final result = await getNewsByFilterUsecase(
      FilterParams(
        filterQuery: event.filterNewsStatus.name,
        searchQuery: event.category.name,
      ),
    );

    result.fold(
      (l) => emit(
        state.copyWith(getNewsStatus: ErrorOnGettingNewsStatus(l.message)),
      ),
      (r) => emit(state.copyWith(getNewsStatus: GetNewsCompletedStatus(r))),
    );
  }

  Future<void> _filterNews(
    FilterNewsEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(getNewsStatus: LoadingNewsStatus()));

    final result = await getNewsByFilterUsecase(
      FilterParams(
        filterQuery: event.filterQuery.name,
        searchQuery: event.searchQuery,
      ),
    );

    result.fold(
      (l) => emit(
        state.copyWith(getNewsStatus: ErrorOnGettingNewsStatus(l.message)),
      ),
      (r) => emit(
        state.copyWith(
          getNewsStatus: GetNewsCompletedStatus(r),
          selectedFilter: event.filterQuery,
        ),
      ),
    );
  }
}

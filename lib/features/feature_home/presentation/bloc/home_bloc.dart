import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/entities/get_news_entity.dart';
import 'package:news_app_4_clean_architecture_bloc/features/feature_home/domain/usecases/get_news_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNewsUseCase getNewsUseCase;

  HomeBloc({required this.getNewsUseCase})
    : super(HomeState(getNewsStatus: LoadingNewsStatus())) {
    on<LoadNewsEvent>(_loadNews);
  }

  Future<void> _loadNews(LoadNewsEvent event, Emitter emit) async {
    emit(state.copyWith(getNewsStatus: LoadingNewsStatus()));

    final result = await getNewsUseCase(event.query);

    result.fold(
      (l) => emit(
        state.copyWith(getNewsStatus: ErrorOnGettingNewsStatus(l.message)),
      ),
      (r) => emit(state.copyWith(getNewsStatus: GetNewsCompletedStatus(r))),
    );
  }
}

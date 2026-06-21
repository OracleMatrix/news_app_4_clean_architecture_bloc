part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {}

class LoadNewsEvent extends HomeEvent {
  final String query;
  final FilterNewsStatus filterNewsStatus;

  LoadNewsEvent({required this.query, required this.filterNewsStatus});

  @override
  List<Object?> get props => [query, filterNewsStatus];
}

class ChangeCategoryEvent extends HomeEvent {
  final Category category;
  final FilterNewsStatus filterNewsStatus;

  ChangeCategoryEvent({required this.category, required this.filterNewsStatus});

  @override
  List<Object?> get props => [category, filterNewsStatus];
}

class FilterNewsEvent extends HomeEvent {
  final FilterNewsStatus filterQuery;
  final String searchQuery;

  FilterNewsEvent({required this.filterQuery, required this.searchQuery});

  @override
  List<Object?> get props => [filterQuery, searchQuery];
}

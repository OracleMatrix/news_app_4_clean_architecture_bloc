part of 'home_bloc.dart';

enum Category {
  technology('technology'),
  general('general'),
  business('business'),
  entertainment('entertainment'),
  health('health'),
  science('science'),
  sports('sports'),
  world('world');

  final String name;

  const Category(this.name);
}

enum FilterNewsStatus {
  popularity('popularity'),
  publishedAt('publishedAt'),
  relevancy('relevancy');

  final String name;

  const FilterNewsStatus(this.name);
}

class HomeState extends Equatable {
  final GetNewsStatus getNewsStatus;
  final Category selectedCategory;
  final FilterNewsStatus selectedFilter;
  const HomeState({
    required this.getNewsStatus,
    required this.selectedCategory,
    required this.selectedFilter,
  });

  HomeState copyWith({
    GetNewsStatus? getNewsStatus,
    Category? selectedCategory,
    FilterNewsStatus? selectedFilter,
  }) {
    return HomeState(
      getNewsStatus: getNewsStatus ?? this.getNewsStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object?> get props => [getNewsStatus, selectedCategory, selectedFilter];
}

abstract class GetNewsStatus extends Equatable {}

class LoadingNewsStatus extends GetNewsStatus {
  @override
  List<Object?> get props => [];
}

class ErrorOnGettingNewsStatus extends GetNewsStatus {
  final String message;

  ErrorOnGettingNewsStatus(this.message);

  @override
  List<Object?> get props => [message];
}

class GetNewsCompletedStatus extends GetNewsStatus {
  final GetNewsEntity getNewsEntity;

  GetNewsCompletedStatus(this.getNewsEntity);

  @override
  List<Object?> get props => [getNewsEntity];
}

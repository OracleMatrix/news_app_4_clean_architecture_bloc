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
  final GetNewsEntity? getNewsEntity;
  final String? errorMessage;

  const HomeState({
    required this.getNewsStatus,
    required this.selectedCategory,
    required this.selectedFilter,
    this.getNewsEntity,
    this.errorMessage,
  });

  HomeState copyWith({
    GetNewsStatus? getNewsStatus,
    Category? selectedCategory,
    FilterNewsStatus? selectedFilter,
    GetNewsEntity? getNewsEntity,
    String? errorMessage,
  }) {
    return HomeState(
      getNewsStatus: getNewsStatus ?? this.getNewsStatus,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      getNewsEntity: getNewsEntity ?? this.getNewsEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        getNewsStatus,
        selectedCategory,
        selectedFilter,
        getNewsEntity,
        errorMessage,
      ];
}

enum GetNewsStatus { loading, completed, error }

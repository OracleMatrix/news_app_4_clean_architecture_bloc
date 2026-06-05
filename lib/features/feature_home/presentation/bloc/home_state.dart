part of 'home_bloc.dart';

class HomeState extends Equatable {
  final GetNewsStatus getNewsStatus;

  const HomeState({required this.getNewsStatus});

  HomeState copyWith({GetNewsStatus? getNewsStatus}) {
    return HomeState(getNewsStatus: getNewsStatus ?? this.getNewsStatus);
  }

  @override
  List<Object?> get props => [getNewsStatus];
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

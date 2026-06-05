part of 'home_bloc.dart';

@immutable
sealed class HomeEvent extends Equatable {}

class LoadNewsEvent extends HomeEvent {
  final String query;

  LoadNewsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

part of 'news_details_bloc.dart';

class NewsDetailsState extends Equatable {
  final ShareStatus shareStatus;
  final String? errorMessage;

  const NewsDetailsState({
    required this.shareStatus,
    this.errorMessage,
  });

  NewsDetailsState copyWith({
    ShareStatus? shareStatus,
    String? errorMessage,
  }) {
    return NewsDetailsState(
      shareStatus: shareStatus ?? this.shareStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [shareStatus, errorMessage];
}

enum ShareStatus { initial, loading, success, error }


part of 'news_details_bloc.dart';

class NewsDetailsState extends Equatable {
  final ShareStatus shareStatus;

  const NewsDetailsState({required this.shareStatus});

  NewsDetailsState copyWith({ShareStatus? shareStatus}) {
    return NewsDetailsState(
      shareStatus: shareStatus ?? this.shareStatus,
    );
  }

  @override
  List<Object?> get props => [shareStatus];
}

abstract class ShareStatus extends Equatable {}

class ShareInitialStatus extends ShareStatus {
  @override
  List<Object?> get props => [];
}

class ShareLoadingStatus extends ShareStatus {
  @override
  List<Object?> get props => [];
}

class ShareSuccessStatus extends ShareStatus {
  @override
  List<Object?> get props => [];
}

class ShareErrorStatus extends ShareStatus {
  final String errorMessage;

  ShareErrorStatus(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

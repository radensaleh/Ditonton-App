part of 'recommendation_tv_bloc.dart';

@immutable
abstract class RecommendationTvState extends Equatable {
  const RecommendationTvState();

  @override
  List<Object?> get props => [];
}

class RecommendationTvInitialState extends RecommendationTvState {}

class RecommendationTvLoadingState extends RecommendationTvState {}

class RecommendationTvHasDataState extends RecommendationTvState {
  final List<TV> result;

  const RecommendationTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

class RecommendationTvErrorState extends RecommendationTvState {
  final String message;

  const RecommendationTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

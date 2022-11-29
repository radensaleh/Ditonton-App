part of 'recommendation_tv_bloc.dart';

@immutable
abstract class RecommendationTvEvent extends Equatable {
  const RecommendationTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchRecommendationTvShow extends RecommendationTvEvent {
  final int id;

  const FetchRecommendationTvShow({required this.id});

  @override
  List<Object?> get props => [id];
}

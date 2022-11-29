part of 'top_rated_tv_bloc.dart';

@immutable
abstract class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object?> get props => [];
}

class TopRatedTvInitialState extends TopRatedTvState {}

class TopRatedTvLoadingState extends TopRatedTvState {}

class TopRatedTvErrorState extends TopRatedTvState {
  final String message;

  const TopRatedTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

class TopRatedTvHasDataState extends TopRatedTvState {
  final List<TV> result;

  const TopRatedTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

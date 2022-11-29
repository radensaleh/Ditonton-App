part of 'popular_tv_bloc.dart';

@immutable
abstract class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object?> get props => [];
}

class PopularTvInitialState extends PopularTvState {}

class PopularTvLoadingState extends PopularTvState {}

class PopularTvHasDataState extends PopularTvState {
  final List<TV> result;

  const PopularTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

class PopularTvErrorState extends PopularTvState {
  final String message;

  const PopularTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

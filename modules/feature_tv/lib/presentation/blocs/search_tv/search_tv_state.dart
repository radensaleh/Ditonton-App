part of 'search_tv_bloc.dart';

@immutable
abstract class SearchTvState extends Equatable {
  const SearchTvState();

  @override
  List<Object?> get props => [];
}

class SearchTvInitialState extends SearchTvState {}

class SearchTvLoadingState extends SearchTvState {}

class SearchTvEmptyState extends SearchTvState {}

class SearchTvHasDataState extends SearchTvState {
  final List<TV> result;

  const SearchTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

class SearchTvErrorState extends SearchTvState {
  final String message;

  const SearchTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

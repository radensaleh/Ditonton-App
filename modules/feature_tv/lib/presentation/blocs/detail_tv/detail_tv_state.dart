part of 'detail_tv_bloc.dart';

@immutable
abstract class DetailTvState extends Equatable {
  const DetailTvState();

  @override
  List<Object?> get props => [];
}

class DetailTvInitialState extends DetailTvState {}

class DetailTvLoadingState extends DetailTvState {}

class DetailTvHasDataState extends DetailTvState {
  final TVDetail result;

  const DetailTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

class DetailTvErrorState extends DetailTvState {
  final String message;

  const DetailTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

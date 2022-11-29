part of 'on_the_air_tv_bloc.dart';

@immutable
abstract class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();

  @override
  List<Object?> get props => [];
}

class OnTheAirTvInitialState extends OnTheAirTvState {}

class OnTheAirTvLoadingState extends OnTheAirTvState {}

class OnTheAirTvHasDataState extends OnTheAirTvState {
  final List<TV> result;

  const OnTheAirTvHasDataState({required this.result});

  @override
  List<Object?> get props => [result];
}

class OnTheAirTvErrorState extends OnTheAirTvState {
  final String message;

  const OnTheAirTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

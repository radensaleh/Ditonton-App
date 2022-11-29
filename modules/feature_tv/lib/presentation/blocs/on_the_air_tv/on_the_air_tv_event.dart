part of 'on_the_air_tv_bloc.dart';

@immutable
abstract class OnTheAirTvEvent extends Equatable {
  const OnTheAirTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchOnTheAirTvShows extends OnTheAirTvEvent {}

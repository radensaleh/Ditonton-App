part of 'top_rated_tv_bloc.dart';

@immutable
abstract class TopRatedTvEvent extends Equatable {
  const TopRatedTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchTopRatedTvShows extends TopRatedTvEvent {}

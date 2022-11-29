part of 'watchlist_tv_bloc.dart';

@immutable
abstract class WatchlistTvEvent extends Equatable {
  const WatchlistTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchWatchlistTvShows extends WatchlistTvEvent {}

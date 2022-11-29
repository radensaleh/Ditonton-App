part of 'watchlist_status_tv_cubit.dart';

@immutable
class WatchlistStatusTvState extends Equatable {
  final bool isAddedWatchlist;
  final String message;

  const WatchlistStatusTvState({
    required this.isAddedWatchlist,
    required this.message,
  });

  @override
  List<Object> get props => [isAddedWatchlist];
}

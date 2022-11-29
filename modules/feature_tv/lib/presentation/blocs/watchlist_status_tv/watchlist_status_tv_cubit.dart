import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:feature_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:feature_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:meta/meta.dart';

part 'watchlist_status_tv_state.dart';

class WatchlistStatusTvCubit extends Cubit<WatchlistStatusTvState> {
  final GetWatchlistTVStatus getWatchlistTVStatus;
  final SaveWatchlistTV saveWatchlistTV;
  final RemoveWatchlistTV removeWatchlistTV;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  WatchlistStatusTvCubit({
    required this.getWatchlistTVStatus,
    required this.saveWatchlistTV,
    required this.removeWatchlistTV,
  }) : super(
            const WatchlistStatusTvState(isAddedWatchlist: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchlistTVStatus.execute(id);
    emit(WatchlistStatusTvState(isAddedWatchlist: result, message: ''));
  }

  Future<void> addWatchlistTV(TVDetail tvDetail) async {
    final result = await saveWatchlistTV.execute(tvDetail);
    final getStatus = await getWatchlistTVStatus.execute(tvDetail.id);

    result.fold(
      (failure) => emit(WatchlistStatusTvState(
          isAddedWatchlist: getStatus, message: failure.message)),
      (data) => emit(
          WatchlistStatusTvState(isAddedWatchlist: getStatus, message: data)),
    );
  }

  Future<void> removeFromWatchlistTV(TVDetail tvDetail) async {
    final result = await removeWatchlistTV.execute(tvDetail);
    final getStatus = await getWatchlistTVStatus.execute(tvDetail.id);

    result.fold(
      (failure) => emit(WatchlistStatusTvState(
          isAddedWatchlist: getStatus, message: failure.message)),
      (data) => emit(
          WatchlistStatusTvState(isAddedWatchlist: getStatus, message: data)),
    );
  }
}

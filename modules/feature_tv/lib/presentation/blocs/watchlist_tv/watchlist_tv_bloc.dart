import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:meta/meta.dart';

part 'watchlist_tv_event.dart';
part 'watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTVShows getWatchlistTVShows;

  WatchlistTvBloc({required this.getWatchlistTVShows})
      : super(WatchlistTvInitialState()) {
    on<WatchlistTvEvent>((event, emit) async {
      emit(WatchlistTvLoadingState());

      final result = await getWatchlistTVShows.execute();

      result.fold(
        (failure) => emit(WatchlistTvErrorState(message: failure.message)),
        (data) => emit(WatchlistTvHasDataState(result: data)),
      );
    });
  }
}

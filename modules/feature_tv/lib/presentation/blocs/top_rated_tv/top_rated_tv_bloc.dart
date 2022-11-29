import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:meta/meta.dart';

part 'top_rated_tv_event.dart';
part 'top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTVShows getTopRatedTVShows;

  TopRatedTvBloc({required this.getTopRatedTVShows})
      : super(TopRatedTvInitialState()) {
    on<FetchTopRatedTvShows>((event, emit) async {
      emit(TopRatedTvLoadingState());

      final result = await getTopRatedTVShows.execute();

      result.fold(
        (failure) => emit(TopRatedTvErrorState(message: failure.message)),
        (data) => emit(TopRatedTvHasDataState(result: data)),
      );
    });
  }
}

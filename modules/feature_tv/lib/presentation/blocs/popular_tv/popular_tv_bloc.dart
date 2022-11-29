import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_popular_tv_shows.dart';
import 'package:meta/meta.dart';

part 'popular_tv_event.dart';
part 'popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTVShows getPopularTVShows;

  PopularTvBloc({required this.getPopularTVShows})
      : super(PopularTvInitialState()) {
    on<FetchPopularTvShows>((event, emit) async {
      emit(PopularTvLoadingState());

      final result = await getPopularTVShows.execute();

      result.fold(
        (failure) => emit(PopularTvErrorState(message: failure.message)),
        (data) => emit(PopularTvHasDataState(result: data)),
      );
    });
  }
}

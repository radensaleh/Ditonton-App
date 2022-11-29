import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:meta/meta.dart';

part 'on_the_air_tv_event.dart';
part 'on_the_air_tv_state.dart';

class OnTheAirTvBloc extends Bloc<OnTheAirTvEvent, OnTheAirTvState> {
  final GetOnTheAirTVShows getOnTheAirTVShows;

  OnTheAirTvBloc({required this.getOnTheAirTVShows})
      : super(OnTheAirTvInitialState()) {
    on<FetchOnTheAirTvShows>((event, emit) async {
      emit(OnTheAirTvLoadingState());

      final result = await getOnTheAirTVShows.execute();

      result.fold(
        (failure) => emit(OnTheAirTvErrorState(message: failure.message)),
        (data) => emit(OnTheAirTvHasDataState(result: data)),
      );
    });
  }
}

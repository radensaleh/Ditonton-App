import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'search_tv_event.dart';
part 'search_tv_state.dart';

class SearchTvBloc extends Bloc<SearchTvEvent, SearchTvState> {
  final SearchTVShows searchTVShows;

  SearchTvBloc({required this.searchTVShows}) : super(SearchTvInitialState()) {
    on<OnQueryTvChange>((event, emit) async {
      emit(SearchTvLoadingState());

      final result = await searchTVShows.execute(event.query);

      result.fold(
        (failed) => emit(SearchTvErrorState(message: failed.message)),
        (data) => emit(SearchTvHasDataState(result: data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) =>
      (events, mapper) => events.debounceTime(duration).flatMap(mapper);
}

import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/search_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;

  SearchMovieBloc({required this.searchMovies})
      : super(SearchMovieEmptyState()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchMovieLoadingState());
      final result = await searchMovies.execute(query);

      result.fold(
        (failure) => emit(SearchMovieErrorState(message: failure.message)),
        (data) => emit(SearchMovieHasDataState(result: data)),
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}

// State
abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieEmptyState extends SearchMovieState {}

class SearchMovieLoadingState extends SearchMovieState {}

class SearchMovieErrorState extends SearchMovieState {
  final String message;

  const SearchMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SearchMovieHasDataState extends SearchMovieState {
  final List<Movie> result;
  const SearchMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchMovieEvent {
  final String query;

  const OnQueryChanged({required this.query});

  @override
  List<Object> get props => [query];
}

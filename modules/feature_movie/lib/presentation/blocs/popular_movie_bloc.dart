import 'package:equatable/equatable.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_popular_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMovieBloc extends Bloc<PopularMovieEvent, PopularMovieState> {
  final GetPopularMovies getPopularMovies;

  PopularMovieBloc({required this.getPopularMovies})
      : super(PopularMovieEmptyState()) {
    on<FetchNowPopularMovies>((event, emit) async {
      emit(PopularMovieLoadingState());
      final result = await getPopularMovies.execute();

      result.fold(
        (failure) => emit(PopularMovieErrorState(message: failure.message)),
        (data) => emit(PopularMovieHasDataState(result: data)),
      );
    });
  }
}

// State
abstract class PopularMovieState extends Equatable {
  const PopularMovieState();

  @override
  List<Object> get props => [];
}

class PopularMovieEmptyState extends PopularMovieState {}

class PopularMovieLoadingState extends PopularMovieState {}

class PopularMovieErrorState extends PopularMovieState {
  final String message;

  const PopularMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class PopularMovieHasDataState extends PopularMovieState {
  final List<Movie> result;

  const PopularMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class PopularMovieEvent extends Equatable {
  const PopularMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPopularMovies extends PopularMovieEvent {}

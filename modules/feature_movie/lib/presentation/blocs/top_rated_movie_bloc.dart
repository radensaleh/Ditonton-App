import 'package:equatable/equatable.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMovieBloc extends Bloc<TopRatedMovieEvent, TopRatedMovieState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMovieBloc({required this.getTopRatedMovies})
      : super(TopRatedMovieEmptyState()) {
    on<FetchNowTopRatedMovies>((event, emit) async {
      emit(TopRatedMovieLoadingState());
      final result = await getTopRatedMovies.execute();

      result.fold(
        (failure) => emit(TopRatedMovieErrorState(message: failure.message)),
        (data) => emit(TopRatedMovieHasDataState(result: data)),
      );
    });
  }
}

// State
abstract class TopRatedMovieState extends Equatable {
  const TopRatedMovieState();

  @override
  List<Object> get props => [];
}

class TopRatedMovieEmptyState extends TopRatedMovieState {}

class TopRatedMovieLoadingState extends TopRatedMovieState {}

class TopRatedMovieErrorState extends TopRatedMovieState {
  final String message;

  const TopRatedMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class TopRatedMovieHasDataState extends TopRatedMovieState {
  final List<Movie> result;

  const TopRatedMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class TopRatedMovieEvent extends Equatable {
  const TopRatedMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowTopRatedMovies extends TopRatedMovieEvent {}

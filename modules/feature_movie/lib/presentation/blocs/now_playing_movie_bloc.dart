import 'package:equatable/equatable.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMovieBloc
    extends Bloc<NowPlayingMovieEvent, NowPlayingMovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMovieBloc({required this.getNowPlayingMovies})
      : super(NowPlayingMovieEmptyState()) {
    on<FetchNowNowPlayingMovies>((event, emit) async {
      emit(NowPlayingMovieLoadingState());
      final result = await getNowPlayingMovies.execute();

      result.fold(
        (failure) => emit(NowPlayingMovieErrorState(message: failure.message)),
        (data) => emit(NowPlayingMovieHasDataState(result: data)),
      );
    });
  }
}

// State
abstract class NowPlayingMovieState extends Equatable {
  const NowPlayingMovieState();

  @override
  List<Object> get props => [];
}

class NowPlayingMovieEmptyState extends NowPlayingMovieState {}

class NowPlayingMovieLoadingState extends NowPlayingMovieState {}

class NowPlayingMovieErrorState extends NowPlayingMovieState {
  final String message;

  const NowPlayingMovieErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class NowPlayingMovieHasDataState extends NowPlayingMovieState {
  final List<Movie> result;

  const NowPlayingMovieHasDataState({required this.result});

  @override
  List<Object> get props => [result];
}

// Event
abstract class NowPlayingMovieEvent extends Equatable {
  const NowPlayingMovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowNowPlayingMovies extends NowPlayingMovieEvent {}

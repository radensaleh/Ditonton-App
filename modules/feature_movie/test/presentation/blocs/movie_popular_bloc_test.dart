import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/get_popular_movies.dart';
import 'package:feature_movie/presentation/blocs/popular_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(getPopularMovies: mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('Movie Bloc, Popular Movie:', () {
    test('initialState should be Empty', () {
      expect(popularMovieBloc.state, PopularMovieEmptyState());
    });

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowPopularMovies()),
      expect: () => [
        PopularMovieLoadingState(),
        PopularMovieHasDataState(result: tMovieList)
      ],
      verify: (bloc) => verify(() => mockGetPopularMovies.execute()),
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchNowPopularMovies()),
      expect: () => [
        PopularMovieLoadingState(),
        const PopularMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetPopularMovies.execute()),
    );
  });
}

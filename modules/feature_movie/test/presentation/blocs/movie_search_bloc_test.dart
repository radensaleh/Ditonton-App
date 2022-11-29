import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_movie/domain/entities/movie.dart';
import 'package:feature_movie/domain/usecases/search_movies.dart';
import 'package:feature_movie/presentation/blocs/search_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

void main() {
  late SearchMovieBloc searchBloc;
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    searchBloc = SearchMovieBloc(searchMovies: mockSearchMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  group('Movie Bloc, Search Movie:', () {
    test('initial state should be empty', () {
      expect(searchBloc.state, SearchMovieEmptyState());
    });

    blocTest<SearchMovieBloc, SearchMovieState>(
      'should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchMovieLoadingState(),
        SearchMovieHasDataState(result: tMovieList),
      ],
      verify: (bloc) {
        verify(() => mockSearchMovies.execute(tQuery));
      },
    );

    blocTest<SearchMovieBloc, SearchMovieState>(
      'should emit [Loading, Error] when get search is unsuccessful',
      build: () {
        when(() => mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const OnQueryChanged(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchMovieLoadingState(),
        const SearchMovieErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) {
        verify(() => mockSearchMovies.execute(tQuery));
      },
    );
  });
}

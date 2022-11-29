import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/top_rated_tv/top_rated_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTopRatedTVShows extends Mock implements GetTopRatedTVShows {}

void main() {
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late TopRatedTvBloc topRatedTVBloc;

  setUp(() {
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    topRatedTVBloc = TopRatedTvBloc(getTopRatedTVShows: mockGetTopRatedTVShows);
  });

  final tTVShow = TV(
    backdropPath: 'backdropPath',
    firstAirDate: DateTime.parse("2021-05-23"),
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: const ['en'],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVShowsList = <TV>[tTVShow];

  group('TV Bloc, Top Rated TV Shows:', () {
    test('initialState should be Empty', () {
      expect(topRatedTVBloc.state, TopRatedTvInitialState());
    });

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTopRatedTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvShows()),
      expect: () => [
        TopRatedTvLoadingState(),
        TopRatedTvHasDataState(result: tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetTopRatedTVShows.execute()),
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTopRatedTVShows.execute()).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTvShows()),
      expect: () => [
        TopRatedTvLoadingState(),
        const TopRatedTvErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTopRatedTVShows.execute()),
    );
  });
}

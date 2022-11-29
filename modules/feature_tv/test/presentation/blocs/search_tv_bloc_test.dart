import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/search_tv_shows.dart';
import 'package:feature_tv/presentation/blocs/search_tv/search_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchTVShows extends Mock implements SearchTVShows {}

void main() {
  late MockSearchTVShows mockSearchTVShows;
  late SearchTvBloc searchTVBloc;

  setUp(() {
    mockSearchTVShows = MockSearchTVShows();
    searchTVBloc = SearchTvBloc(searchTVShows: mockSearchTVShows);
  });

  final tTVShowModel = TV(
    backdropPath: "/qJYUCO1Q8desX7iVDkwxWVnwacZ.jpg",
    firstAirDate: DateTime.parse("2010-09-17"),
    genreIds: const [10759, 16],
    id: 32315,
    name: "Sym-Bionic Titan",
    originCountry: const ["US"],
    originalLanguage: "en",
    originalName: "Sym-Bionic Titan",
    overview:
        "Sym-Bionic Titan is an American animated action science fiction television series created by Genndy Tartakovsky, Paul Rudish, and Bryan Andrews for Cartoon Network. The series focuses on a trio made up of the alien princess Ilana, the rebellious soldier Lance, and the robot Octus; the three are able to combine to create the titular Sym-Bionic Titan. A preview of the series was first shown at the 2009 San Diego Comic-Con International, and further details were revealed at Cartoon Network's 2010 Upfront. The series premiered on September 17, 2010, and ended on April 9, 2011. The series is rated TV-PG-V. Cartoon Network initially ordered 20 episodes; Tartakovsky had hoped to expand on that, but the series was not renewed for another season, as the show 'did not have any toys connected to it.' Although Sym-Bionic Titan has never been released on DVD, All 20 episodes are available on iTunes. On October 7, 2012, reruns of Sym-Bionic Titan began airing on Adult Swim's Toonami block.",
    popularity: 9.693,
    posterPath: "/3UdrghLghvYnsVohWM160RHKPYQ.jpg",
    voteAverage: 8.8,
    voteCount: 85,
  );
  final tTVShowsList = [tTVShowModel];
  const tQuery = 'Titan';

  group('TV Bloc, Search TV Shows:', () {
    test('initialState should be Empty', () {
      expect(searchTVBloc.state, SearchTvInitialState());
    });

    blocTest<SearchTvBloc, SearchTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockSearchTVShows.execute(tQuery))
            .thenAnswer((_) async => Right(tTVShowsList));
        return searchTVBloc;
      },
      act: (bloc) => bloc.add(const OnQueryTvChange(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchTvLoadingState(),
        SearchTvHasDataState(result: tTVShowsList),
      ],
      verify: (bloc) => verify(() => mockSearchTVShows.execute(tQuery)),
    );

    blocTest<SearchTvBloc, SearchTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockSearchTVShows.execute(tQuery)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return searchTVBloc;
      },
      act: (bloc) => bloc.add(const OnQueryTvChange(query: tQuery)),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        SearchTvLoadingState(),
        const SearchTvErrorState(message: 'Server Failure'),
      ],
      verify: (bloc) => verify(() => mockSearchTVShows.execute(tQuery)),
    );
  });
}

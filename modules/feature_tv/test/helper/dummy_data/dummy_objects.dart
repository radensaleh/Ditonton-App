import 'package:feature_tv/data/models/tv_table.dart';
import 'package:feature_tv/domain/entities/episode.dart';
import 'package:feature_tv/domain/entities/genre.dart';
import 'package:feature_tv/domain/entities/season.dart';
import 'package:feature_tv/domain/entities/season_detail.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';

final testTVShow = TV(
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

final testTVShowsList = [testTVShow];

const testTVTable = TVTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVMap = {
  'id': 1,
  'name': 'name',
  'posterPath': 'posterPath',
  'overview': 'overview',
};

const testTVSeasonDetail = SeasonDetail(
  id: '1',
  airDate: '2019-04-22',
  episodes: [
    Episode(
      airDate: '2019-04-22',
      episodeNumber: 1,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: 'productionCode',
      runtime: 21,
      seasonNumber: 1,
      showId: 2,
      stillPath: 'stillPath',
      voteAverage: 2.2,
      voteCount: 1,
      crew: [],
      guestStars: [],
    )
  ],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 1,
  posterPath: 'posterPath',
  seasonNumber: 11,
);

const testTVDetail = TVDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'name')],
  homepage: 'homepage',
  id: 1,
  inProduction: false,
  languages: ['us'],
  lastAirDate: null,
  name: 'name',
  numberOfEpisodes: 1,
  numberOfSeasons: 2,
  seasons: [
    Season(
      airDate: null,
      episodeCount: 1,
      id: 2,
      name: 'name',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 2,
    )
  ],
  originCountry: ['originCountry'],
  originalLanguage: 'originalLanguage',
  originalName: 'originalName',
  overview: 'overview',
  popularity: 2.2,
  posterPath: 'posterPath',
  productionCompanies: ['productionCompanies'],
  status: 'status',
  tagline: 'tagline',
  type: 'type',
  voteAverage: 2.1,
  voteCount: 22,
);

final testWatchlistTVShow = TV.watchlist(
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  name: 'name',
);

const testSeasonDetail = SeasonDetail(
  id: "1",
  airDate: "airDate",
  episodes: [
    Episode(
      airDate: "airDate",
      episodeNumber: 2,
      id: 1,
      name: 'name',
      overview: 'overview',
      productionCode: '1',
      runtime: 3,
      seasonNumber: 1,
      showId: 2,
      stillPath: 'stillPath',
      voteAverage: 2.1,
      voteCount: 22,
      crew: [],
      guestStars: [],
    ),
  ],
  name: 'name',
  overview: 'overview',
  seasonDetailResponseId: 2,
  posterPath: 'posterPath',
  seasonNumber: 2,
);

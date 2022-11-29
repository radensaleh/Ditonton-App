import 'package:equatable/equatable.dart';

class TV extends Equatable {
  TV({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  TV.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  String? backdropPath;
  DateTime? firstAirDate;
  List<int>? genreIds;
  final int id;
  final String? name;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalName;
  final String? overview;
  double? popularity;
  final String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAirDate,
        genreIds,
        id,
        name,
        originCountry,
        originalLanguage,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}

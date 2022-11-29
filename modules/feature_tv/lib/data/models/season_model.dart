import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/season.dart';

class SeasonModel extends Equatable {
  const SeasonModel({
    required this.airDate,
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final DateTime? airDate;
  final int? episodeCount;
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final int? seasonNumber;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        airDate: json["air_date"] == null || json["air_date"] == ""
            ? null
            : DateTime.parse(json["air_date"]),
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Season toEntity() {
    return Season(
      airDate: airDate,
      episodeCount: episodeCount,
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeCount,
        id,
        name,
        override,
        posterPath,
        seasonNumber,
      ];
}

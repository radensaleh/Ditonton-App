import 'package:equatable/equatable.dart';
import 'package:feature_tv/data/models/tv_season/episode_model.dart';
import 'package:feature_tv/domain/entities/season_detail.dart';

class SeasonDetailResponse extends Equatable {
  const SeasonDetailResponse({
    required this.id,
    required this.airDate,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.seasonDetailResponseId,
    required this.posterPath,
    required this.seasonNumber,
  });

  final String id;
  final dynamic airDate;
  final List<EpisodeModel> episodes;
  final String name;
  final String overview;
  final int seasonDetailResponseId;
  final String? posterPath;
  final int seasonNumber;

  factory SeasonDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeasonDetailResponse(
        id: json["_id"],
        airDate: json["air_date"],
        episodes: List<EpisodeModel>.from(
            json["episodes"].map((x) => EpisodeModel.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        seasonDetailResponseId: json["id"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  SeasonDetail toEntity() {
    return SeasonDetail(
      id: id,
      airDate: airDate,
      episodes: episodes.map((eps) => eps.toEntity()).toList(),
      name: name,
      overview: overview,
      seasonDetailResponseId: seasonDetailResponseId,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodes,
        name,
        overview,
        seasonDetailResponseId,
        posterPath,
        seasonNumber,
      ];
}

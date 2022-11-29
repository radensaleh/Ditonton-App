import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/episode.dart';

class EpisodeModel extends Equatable {
  const EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
    required this.crew,
    required this.guestStars,
  });

  final dynamic airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final String productionCode;
  final int? runtime;
  final int seasonNumber;
  final int showId;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;
  final List<dynamic> crew;
  final List<dynamic> guestStars;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        productionCode: json["production_code"],
        runtime: json["runtime"],
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: json["still_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        crew: List<dynamic>.from(json["crew"].map((x) => x)),
        guestStars: List<dynamic>.from(json["guest_stars"].map((x) => x)),
      );

  Episode toEntity() {
    return Episode(
      airDate: airDate,
      episodeNumber: episodeNumber,
      id: id,
      name: name,
      overview: overview,
      productionCode: productionCode,
      runtime: runtime,
      seasonNumber: seasonNumber,
      showId: showId,
      stillPath: stillPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
      crew: crew,
      guestStars: guestStars,
    );
  }

  @override
  List<Object?> get props => [
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath,
        voteAverage,
        voteCount,
        crew,
        guestStars,
      ];
}

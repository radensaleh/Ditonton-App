part of 'season_detail_tv_bloc.dart';

@immutable
abstract class SeasonDetailTvEvent extends Equatable {
  const SeasonDetailTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchSeasonDetailTvShow extends SeasonDetailTvEvent {
  final int tvId;
  final int seasonNumber;

  const FetchSeasonDetailTvShow({
    required this.tvId,
    required this.seasonNumber,
  });

  @override
  List<Object?> get props => [tvId, seasonNumber];
}

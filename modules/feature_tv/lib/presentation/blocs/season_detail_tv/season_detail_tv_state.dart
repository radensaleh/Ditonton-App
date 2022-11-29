part of 'season_detail_tv_bloc.dart';

@immutable
abstract class SeasonDetailTvState extends Equatable {
  const SeasonDetailTvState();

  @override
  List<Object?> get props => [];
}

class SeasonDetailTvInitialState extends SeasonDetailTvState {}

class SeasonDetailTvLoadingState extends SeasonDetailTvState {}

class SeasonDetailTvHasDataState extends SeasonDetailTvState {
  final SeasonDetail seasonTv;
  final TVDetail detailTv;

  const SeasonDetailTvHasDataState({
    required this.seasonTv,
    required this.detailTv,
  });

  @override
  List<Object?> get props => [seasonTv, detailTv];
}

class SeasonDetailTvErrorState extends SeasonDetailTvState {
  final String message;

  const SeasonDetailTvErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

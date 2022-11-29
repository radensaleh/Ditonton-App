import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/season_detail.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/usecases/get_tv_season_detail.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:meta/meta.dart';

part 'season_detail_tv_event.dart';
part 'season_detail_tv_state.dart';

class SeasonDetailTvBloc
    extends Bloc<SeasonDetailTvEvent, SeasonDetailTvState> {
  final GetTVSeasonDetail getTVSeasonDetail;
  final GetTVShowDetail getTVShowDetail;

  SeasonDetailTvBloc(
      {required this.getTVSeasonDetail, required this.getTVShowDetail})
      : super(SeasonDetailTvInitialState()) {
    on<FetchSeasonDetailTvShow>((event, emit) async {
      emit(SeasonDetailTvLoadingState());

      final seasonTv =
          await getTVSeasonDetail.execute(event.tvId, event.seasonNumber);

      final detailTv = await getTVShowDetail.execute(event.tvId);

      seasonTv.fold(
        (failure) => emit(SeasonDetailTvErrorState(message: failure.message)),
        (dataSeason) {
          detailTv.fold(
            (failure) =>
                emit(SeasonDetailTvErrorState(message: failure.message)),
            (dataDetail) => emit(SeasonDetailTvHasDataState(
              seasonTv: dataSeason,
              detailTv: dataDetail,
            )),
          );
        },
      );
    });
  }
}

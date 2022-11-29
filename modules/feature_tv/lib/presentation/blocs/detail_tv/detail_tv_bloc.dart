import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_detail.dart';
import 'package:meta/meta.dart';

part 'detail_tv_event.dart';
part 'detail_tv_state.dart';

class DetailTvBloc extends Bloc<DetailTvEvent, DetailTvState> {
  final GetTVShowDetail getTVShowDetail;

  DetailTvBloc({required this.getTVShowDetail})
      : super(DetailTvInitialState()) {
    on<FetchDetailTvShow>((event, emit) async {
      emit(DetailTvLoadingState());

      final result = await getTVShowDetail.execute(event.id);

      result.fold(
        (failure) => emit(DetailTvErrorState(message: failure.message)),
        (data) => emit(DetailTvHasDataState(result: data)),
      );
    });
  }
}

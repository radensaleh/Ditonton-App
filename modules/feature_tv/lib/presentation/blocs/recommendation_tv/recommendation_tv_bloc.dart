import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/usecases/get_tv_show_recommendations.dart';
import 'package:meta/meta.dart';

part 'recommendation_tv_event.dart';
part 'recommendation_tv_state.dart';

class RecommendationTvBloc
    extends Bloc<RecommendationTvEvent, RecommendationTvState> {
  final GetTVShowRecommendations getTVShowRecommendations;

  RecommendationTvBloc({required this.getTVShowRecommendations})
      : super(RecommendationTvInitialState()) {
    on<FetchRecommendationTvShow>((event, emit) async {
      emit(RecommendationTvLoadingState());

      final result = await getTVShowRecommendations.execute(event.id);

      result.fold(
        (failure) => emit(RecommendationTvErrorState(message: failure.message)),
        (data) => emit(RecommendationTvHasDataState(result: data)),
      );
    });
  }
}

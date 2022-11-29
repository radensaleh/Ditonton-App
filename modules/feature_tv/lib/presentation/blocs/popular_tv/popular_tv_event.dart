part of 'popular_tv_bloc.dart';

@immutable
abstract class PopularTvEvent extends Equatable {
  const PopularTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchPopularTvShows extends PopularTvEvent {}

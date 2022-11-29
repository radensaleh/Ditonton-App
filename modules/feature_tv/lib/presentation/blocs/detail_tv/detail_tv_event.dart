part of 'detail_tv_bloc.dart';

@immutable
abstract class DetailTvEvent extends Equatable {
  const DetailTvEvent();

  @override
  List<Object?> get props => [];
}

class FetchDetailTvShow extends DetailTvEvent {
  final int id;

  const FetchDetailTvShow({required this.id});

  @override
  List<Object?> get props => [];
}

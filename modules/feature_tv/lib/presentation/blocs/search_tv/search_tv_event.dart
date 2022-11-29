part of 'search_tv_bloc.dart';

@immutable
abstract class SearchTvEvent extends Equatable {
  const SearchTvEvent();

  @override
  List<Object?> get props => [];
}

class OnQueryTvChange extends SearchTvEvent {
  final String query;

  const OnQueryTvChange({required this.query});

  @override
  List<Object?> get props => [query];
}

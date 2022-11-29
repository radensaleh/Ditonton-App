import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class SearchTVShows {
  final TVRepository repository;

  SearchTVShows({required this.repository});

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTVShows(query);
  }
}

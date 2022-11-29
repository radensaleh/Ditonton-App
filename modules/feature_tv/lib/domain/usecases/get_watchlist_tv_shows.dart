import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetWatchlistTVShows {
  final TVRepository repository;

  GetWatchlistTVShows({required this.repository});

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getWatchlistTVShows();
  }
}

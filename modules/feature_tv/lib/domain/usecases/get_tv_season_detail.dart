import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/season_detail.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetTVSeasonDetail {
  final TVRepository repository;

  GetTVSeasonDetail({required this.repository});

  Future<Either<Failure, SeasonDetail>> execute(int tvId, int seasonNumber) {
    return repository.getSeasonDetail(tvId, seasonNumber);
  }
}

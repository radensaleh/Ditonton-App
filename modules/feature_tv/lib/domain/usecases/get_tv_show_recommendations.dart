import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetTVShowRecommendations {
  final TVRepository repository;

  GetTVShowRecommendations({required this.repository});

  Future<Either<Failure, List<TV>>> execute(int id) {
    return repository.getTVShowRecommendations(id);
  }
}

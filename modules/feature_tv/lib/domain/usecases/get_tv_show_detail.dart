import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class GetTVShowDetail {
  final TVRepository repository;

  GetTVShowDetail({required this.repository});

  Future<Either<Failure, TVDetail>> execute(int id) {
    return repository.getTVShowDetail(id);
  }
}

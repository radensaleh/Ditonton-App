import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';
import 'package:feature_tv/domain/repositories/tv_repository.dart';

class SaveWatchlistTV {
  final TVRepository repository;

  SaveWatchlistTV({required this.repository});

  Future<Either<Failure, String>> execute(TVDetail tv) {
    return repository.saveWatchlistTV(tv);
  }
}

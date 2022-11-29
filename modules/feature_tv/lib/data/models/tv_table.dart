import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/tv.dart';
import 'package:feature_tv/domain/entities/tv_detail.dart';

class TVTable extends Equatable {
  final int id;
  final String? name;
  final String? posterPath;
  final String? overview;

  const TVTable({
    required this.id,
    required this.name,
    required this.posterPath,
    required this.overview,
  });

  factory TVTable.fromMap(Map<String, dynamic> map) => TVTable(
        id: map['id'],
        name: map['name'],
        posterPath: map['posterPath'],
        overview: map['overview'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'posterPath': posterPath,
        'overview': overview,
      };

  factory TVTable.fromEntity(TVDetail tv) => TVTable(
      id: tv.id,
      name: tv.name,
      posterPath: tv.posterPath,
      overview: tv.overview);

  TV toEntity() => TV.watchlist(
      id: id, name: name, posterPath: posterPath, overview: overview);

  @override
  List<Object?> get props => [id, name, posterPath, overview];
}

import 'package:equatable/equatable.dart';
import 'package:feature_tv/domain/entities/genre.dart';

class GenreModel extends Equatable {
  const GenreModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Genre toEntity() {
    return Genre(id: id, name: name);
  }

  @override
  List<Object?> get props => [id, name];
}

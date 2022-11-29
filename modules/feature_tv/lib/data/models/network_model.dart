import 'package:equatable/equatable.dart';

class NetworkModel extends Equatable {
  const NetworkModel({
    required this.id,
    required this.name,
    required this.logoPath,
    required this.originCountry,
  });

  final int id;
  final String? name;
  final String? logoPath;
  final String? originCountry;

  factory NetworkModel.fromJson(Map<String, dynamic> json) => NetworkModel(
        id: json["id"],
        name: json["name"],
        logoPath: json["logo_path"],
        originCountry: json["origin_country"],
      );

  @override
  List<Object?> get props => [
        id,
        name,
        logoPath,
        originCountry,
      ];
}

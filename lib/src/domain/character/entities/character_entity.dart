import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String locationName;
  final String episodes;
  final String image;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.locationName,
    required this.episodes,
    required this.image,
  });

  List<String> get episode => episodes
      .replaceAll(RegExp(r'[\[\]]'), '') // Remove os colchetes
      .split(',') // Divide pela vírgula
      .map((e) => e.trim()) // Remove espaços em branco extras
      .toList();

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        locationName,
        episodes,
        image,
      ];
}

import 'package:floor/floor.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';

@Entity(
  primaryKeys: [
    'id',
  ],
  tableName: 'characters',
)
class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.locationName,
    required super.episodes,
    required super.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      locationName: json['location']['name'] as String,
      episodes:
          json['episode'] is List<dynamic> ? json['episode'].toString() : '[]',
      image: json['image'] as String,
    );
  }

  factory CharacterModel.fromEntity(CharacterEntity entity) {
    return CharacterModel(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      species: entity.species,
      type: entity.type,
      gender: entity.gender,
      locationName: entity.locationName,
      episodes: entity.episodes,
      image: entity.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'location': {
        'name': locationName,
      },
      'episodes': episodes,
      'image': image,
    };
  }
}

import 'package:rmapp/src/common/models/info_model.dart';
import 'package:rmapp/src/data/models/character_model.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';

class CharacterReturnModel extends CharacterReturnEntity {
  const CharacterReturnModel({
    required super.info,
    required super.results,
  });

  factory CharacterReturnModel.fromJson(Map<String, dynamic> json) {
    return CharacterReturnModel(
      info: InfoModel.fromJson(json['info'] as Map<String, dynamic>),
      results: (json['results'] as List<dynamic>)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

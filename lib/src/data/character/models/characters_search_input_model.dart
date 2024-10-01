import 'package:rmapp/src/data/character/models/filter_character_model.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';

class CharactersSearchInputModel extends CharactersSearchInput {
  const CharactersSearchInputModel({
    required super.page,
    required super.search,
    required FilterCharacterModel filterCharacter,
  }) : super(
          filterCharacter: filterCharacter,
        );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'page': page,
      if (search.isNotEmpty) 'name': search,
    };
    if (filterCharacter is FilterCharacterModel) {
      map.addAll((filterCharacter as FilterCharacterModel).toJson());
    }

    return map;
  }

  factory CharactersSearchInputModel.fromEntity(CharactersSearchInput entity) {
    return CharactersSearchInputModel(
      page: entity.page,
      search: entity.search,
      filterCharacter: FilterCharacterModel(
        genderEnum: entity.filterCharacter.genderEnum,
        specieEnum: entity.filterCharacter.specieEnum,
        statusEnum: entity.filterCharacter.statusEnum,
      ),
    );
  }
}

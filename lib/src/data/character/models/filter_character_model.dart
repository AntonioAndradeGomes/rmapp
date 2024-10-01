import 'package:rmapp/src/domain/character/entities/enums.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';

class FilterCharacterModel extends FilterCharacter {
  const FilterCharacterModel({
    super.genderEnum,
    super.specieEnum,
    super.statusEnum,
  });

  Map<String, dynamic> toJson() {
    return {
      if (genderEnum != GenderEnum.all)
        'gender': genderEnum.label.toLowerCase(),
      if (specieEnum != SpecieEnum.all)
        'species': specieEnum.label.toLowerCase(),
      if (statusEnum != StatusEnum.all)
        'status': statusEnum.label.toLowerCase(),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/enums.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';

class FilterController extends ValueNotifier<FilterCharacter> {
  FilterController() : super(FilterCharacter());

  void setFilter(FilterCharacter filter) {
    value = filter;
  }

  void setStatus(StatusEnum status) {
    value = value.copyWith(
      statusEnum: status,
    );
  }

  void setSpecie(SpecieEnum specie) {
    value = value.copyWith(
      specieEnum: specie,
    );
  }

  void setGender(GenderEnum gender) {
    value = value.copyWith(
      genderEnum: gender,
    );
  }
}

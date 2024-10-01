import 'package:equatable/equatable.dart';
import 'package:rmapp/src/domain/character/entities/enums.dart';

class FilterCharacter extends Equatable {
  final StatusEnum statusEnum;
  final SpecieEnum specieEnum;
  final GenderEnum genderEnum;

  const FilterCharacter({
    this.statusEnum = StatusEnum.all,
    this.specieEnum = SpecieEnum.all,
    this.genderEnum = GenderEnum.all,
  });

  FilterCharacter copyWith({
    StatusEnum? statusEnum,
    SpecieEnum? specieEnum,
    GenderEnum? genderEnum,
  }) {
    return FilterCharacter(
      statusEnum: statusEnum ?? this.statusEnum,
      specieEnum: specieEnum ?? this.specieEnum,
      genderEnum: genderEnum ?? this.genderEnum,
    );
  }

  @override
  List<Object?> get props => [
        specieEnum,
        statusEnum,
        genderEnum,
      ];
}

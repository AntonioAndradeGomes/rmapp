import 'package:flutter_test/flutter_test.dart';
import 'package:rmapp/src/dependencies/dependencies_injector_imports.dart';
import 'package:rmapp/src/domain/character/entities/enums.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';

void main() {
  group(
    'FilterController Tests',
    () {
      late FilterController controller;

      setUp(() {
        controller = FilterController();
      });
      test(
        'Should return the initial state',
        () async {
          expect(controller.value, isA<FilterCharacter>());
          final state = controller.value;
          expect(state.genderEnum, GenderEnum.all);
          expect(state.specieEnum, SpecieEnum.all);
          expect(state.statusEnum, StatusEnum.all);
        },
      );

      test(
        'Should return the changed state',
        () async {
          final filterCharacter = FilterCharacter(
            genderEnum: GenderEnum.male,
            specieEnum: SpecieEnum.alien,
            statusEnum: StatusEnum.dead,
          );
          controller.setFilter(filterCharacter);

          expect(controller.value, filterCharacter);
        },
      );

      test(
        'Must change status',
        () async {
          controller.setStatus(StatusEnum.alive);
          expect(controller.value.statusEnum, StatusEnum.alive);
        },
      );

      test(
        'Must change gender',
        () async {
          controller.setGender(GenderEnum.female);
          expect(controller.value.genderEnum, GenderEnum.female);
        },
      );
      test(
        'Must change specie',
        () async {
          controller.setSpecie(SpecieEnum.human);
          expect(controller.value.specieEnum, SpecieEnum.human);
        },
      );
    },
  );
}

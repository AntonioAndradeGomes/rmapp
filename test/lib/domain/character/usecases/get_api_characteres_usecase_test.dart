import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/character/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';
import 'package:rmapp/src/domain/character/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/character/usecases/get_api_characteres_usecase.dart';

import '../../../../mocks.dart';

void main() {
  group(
    'Tests in GetApiCharacteresUsecase',
    () {
      late CharactersRepository repository;
      late GetApiCharacteresUsecase usecase;

      setUp(() {
        repository = CharactersRepositoryMock();
        usecase = GetApiCharacteresUsecase(
          repository: repository,
        );
      });

      test(
        'Must return a CharacterReturnEntity',
        () async {
          when(
            () => repository.getCaractersFromApi(
              any(),
              any(),
            ),
          ).thenAnswer(
            (_) async => const Success(resultCharacterReturnModel),
          );

          final test = await usecase.call(
            const CharactersSearchInput(
              page: 1,
              search: '',
            ),
          );

          expect(test.isSuccess(), true);
          expect(test.isError(), false);
          expect(test.getOrNull(), isA<CharacterReturnEntity>());
          expect(
              test.getOrNull()!.info, equals(resultCharacterReturnModel.info));
          expect(test.getOrNull()!.results.length, 5);
        },
      );

      test(
        'Should return a failure',
        () async {
          when(
            () => repository.getCaractersFromApi(
              any(),
              any(),
            ),
          ).thenAnswer(
            (_) async => const Failure(customExceptionMock),
          );

          final test = await usecase.call(
            const CharactersSearchInput(
              page: 1,
              search: '',
            ),
          );

          expect(test.isSuccess(), false);
          expect(test.isError(), true);
          expect(test.exceptionOrNull(), isA<CustomException>());
          expect(test.exceptionOrNull(), equals(customExceptionMock));
        },
      );
    },
  );
}

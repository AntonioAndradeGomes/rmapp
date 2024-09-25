import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/character/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/character/usecases/save_character_usecase.dart';

import '../../../../../mocks.dart';

void main() {
  group(
    'Tests in SaveCharacterUsecase',
    () {
      late CharactersRepository repository;
      late SaveCharacterUsecase usecase;

      setUp(() {
        repository = CharactersRepositoryMock();
        usecase = SaveCharacterUsecase(
          repository: repository,
        );
      });

      test(
        'must save a CharacterEntity',
        () async {
          when(
            () => repository.saveCharactersInLocalStorage(
              resultCharacterReturnModel.results.first,
            ),
          ).thenAnswer(
            (_) async => Success(NoParams()),
          );
          final test =
              await usecase.call(resultCharacterReturnModel.results.first);

          expect(test.isSuccess(), true);
          expect(test.getOrNull(), isA<NoParams>());
        },
      );

      test(
        'should return the CustomException',
        () async {
          when(
            () => repository.saveCharactersInLocalStorage(
              resultCharacterReturnModel.results.first,
            ),
          ).thenAnswer(
            (_) async => const Failure(customExceptionMock),
          );

          final test =
              await usecase.call(resultCharacterReturnModel.results.first);
          expect(test.isSuccess(), false);
          expect(test.isError(), true);
          expect(test.exceptionOrNull(), isA<CustomException>());
          expect(test.exceptionOrNull(), equals(customExceptionMock));
        },
      );
    },
  );
}

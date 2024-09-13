import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/usecases/get_favorites_characteres_usecase.dart';

import '../../../mocks.dart';

void main() {
  group(
    'Tests in GetFavoritesCharacteresUseCase',
    () {
      late CharactersRepository repository;
      late GetFavoritesCharacteresUseCase usecase;

      setUp(() {
        repository = CharactersRepositoryMock();
        usecase = GetFavoritesCharacteresUseCase(
          repository: repository,
        );
      });

      test(
        'Must return a list of CharacterEntity',
        () async {
          when(
            () => repository.getCharactersFavorites(),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel.results),
          );

          final test = await usecase.call(NoParams());

          expect(test.isSuccess(), true);
          expect(test.isError(), false);
          expect(test.getOrNull(), isA<List<CharacterEntity>>());
          expect(test.getOrNull()!.length, 5);
        },
      );

      test(
        'Should return a failure',
        () async {
          when(
            () => repository.getCharactersFavorites(),
          ).thenAnswer(
            (_) async => const Failure(customExceptionMock),
          );

          final test = await usecase.call(NoParams());

          expect(test.isSuccess(), false);
          expect(test.isError(), true);
          expect(test.exceptionOrNull(), isA<CustomException>());
          expect(test.exceptionOrNull(), equals(customExceptionMock));
        },
      );
    },
  );
}

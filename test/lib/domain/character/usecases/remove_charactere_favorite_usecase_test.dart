import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/character/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/character/usecases/remove_character_favorite_usecase.dart';

import '../../../../mocks.dart';

void main() {
  group(
    'Tests in RemoveCharacterFavoriteUsecase',
    () {
      late CharactersRepository repository;
      late RemoveCharacterFavoriteUsecase usecase;

      setUp(() {
        repository = CharactersRepositoryMock();
        usecase = RemoveCharacterFavoriteUsecase(
          repository: repository,
        );
      });

      test(
        'should return the id of the removed entity',
        () async {
          when(
            () => repository.removeCharacterInLocalStorage(
                resultCharacterReturnModel.results.first),
          ).thenAnswer(
            (_) async => const Success(1),
          );
          final test =
              await usecase.call(resultCharacterReturnModel.results.first);

          expect(test.isSuccess(), true);
          expect(test.getOrNull(), 1);
        },
      );

      test(
        'should return the CustomException',
        () async {
          when(
            () => repository.removeCharacterInLocalStorage(
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

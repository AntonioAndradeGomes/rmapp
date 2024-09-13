import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/usecases/get_characteres_from_urls_usecase.dart';
import '../../../mocks.dart';

void main() {
  group(
    'Tests in GetCharacteresFromUrlsUsecase',
    () {
      late CharactersRepository repository;
      late GetCharacteresFromUrlsUsecase usecase;

      setUp(() {
        repository = CharactersRepositoryMock();
        usecase = GetCharacteresFromUrlsUsecase(
          repository: repository,
        );
      });

      test(
        'Should return a list of CharacterEntity',
        () async {
          when(
            () => repository.getCharactersFromUrls(charactersUrlsMock),
          ).thenAnswer(
            (_) async => Success(
              resultCharacterReturnModel.results,
            ),
          );

          final test = await usecase.call(charactersUrlsMock);

          expect(test.isSuccess(), true);
          expect(test.isError(), false);
          expect(test.getOrNull(), isA<List<CharacterEntity>>());
          expect(test.getOrNull()?.length ?? 0, 5);
        },
      );
      test(
        'Should return a CustomException',
        () async {
          when(
            () => repository.getCharactersFromUrls(any()),
          ).thenAnswer(
            (_) async => const Failure(
              customExceptionMock,
            ),
          );

          final test = await usecase.call(charactersUrlsMock);

          expect(test.isSuccess(), false);
          expect(test.isError(), true);
          expect(test.exceptionOrNull(), isA<CustomException>());
          expect(test.exceptionOrNull(), equals(customExceptionMock));
        },
      );
    },
  );
}

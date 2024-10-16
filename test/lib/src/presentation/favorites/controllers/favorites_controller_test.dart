import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/character/usecases/get_favorites_characteres_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/remove_character_favorite_usecase.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_controller.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_state.dart';

import '../../../../../mocks.dart';

class GetFavoritesCharacteresUseCaseMock extends Mock
    implements GetFavoritesCharacteresUseCase {}

class RemoveCharacterFavoriteUsecaseMock extends Mock
    implements RemoveCharacterFavoriteUsecase {}

void main() {
  group(
    'Tests in FavoritesController',
    () {
      late GetFavoritesCharacteresUseCase getFavoritesCharacteresUseCase;
      late RemoveCharacterFavoriteUsecase removeCharacterFavoriteUsecase;
      late FavoritesController controller;

      setUp(
        () {
          getFavoritesCharacteresUseCase = GetFavoritesCharacteresUseCaseMock();
          removeCharacterFavoriteUsecase = RemoveCharacterFavoriteUsecaseMock();
          controller = FavoritesController(
            getFavoritesCharacteresUseCase: getFavoritesCharacteresUseCase,
            removeCharactereFavoriteUsecase: removeCharacterFavoriteUsecase,
          );
        },
      );

      test(
        'It should return the initial state of the controller',
        () async {
          expect(controller.value, isA<LoadingFavoritesState>());
        },
      );

      group(
        'Tests in loadData function',
        () {
          test(
            'It should return success with the list of characters saved in local storage.',
            () async {
              when(
                () => getFavoritesCharacteresUseCase.call(NoParams()),
              ).thenAnswer(
                (_) async => Success(characterListMock),
              );

              await controller.loadData();
              expect(controller.value, isA<SuccessFavoritesState>());
              final list = controller.value.characteres!;

              expect(list, equals(characterListMock));
            },
          );

          test(
            'Should return error status',
            () async {
              when(
                () => getFavoritesCharacteresUseCase.call(NoParams()),
              ).thenAnswer(
                (_) async => Failure(
                  CustomException(),
                ),
              );

              await controller.loadData();
              expect(controller.value, isA<ErrorFavoritesState>());
            },
          );
        },
      );

      group(
        'Tests in removeCharacter',
        () {
          test(
            'must remove an element from the list and update the state',
            () async {
              List<CharacterEntity> list = List.from(characterListMock);
              when(
                () => getFavoritesCharacteresUseCase.call(NoParams()),
              ).thenAnswer(
                (_) async => Success(list),
              );

              await controller.loadData();
              expect(controller.value, isA<SuccessFavoritesState>());
              final itens = controller.value.characteres!;

              expect(itens, equals(list));

              when(() => removeCharacterFavoriteUsecase.call(itens.first))
                  .thenAnswer(
                (_) async => Success(itens.first.id),
              );

              await controller.removeCharacter(itens.first);

              expect(controller.value, isA<SuccessFavoritesState>());
              expect(controller.value.characteres!.length, list.length - 1);
            },
          );

          test(
            'an error must occur',
            () async {
              List<CharacterEntity> list = List.from(characterListMock);
              when(
                () => getFavoritesCharacteresUseCase.call(NoParams()),
              ).thenAnswer(
                (_) async => Success(list),
              );

              await controller.loadData();
              expect(controller.value, isA<SuccessFavoritesState>());
              final itens = controller.value.characteres!;

              expect(itens, equals(list));

              when(() => removeCharacterFavoriteUsecase.call(itens.first))
                  .thenAnswer(
                (_) async => Failure(CustomException()),
              );

              expect(
                () async => await controller.removeCharacter(itens.first),
                throwsA(
                  isA<CustomException>(),
                ),
              );
            },
          );
        },
      );
    },
  );
}

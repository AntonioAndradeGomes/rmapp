import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/dependencies/dependencies_injector_imports.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/pagination_manager.dart';

import '../../../../../../mocks.dart';

class GetApiCharacteresUsecaseMock extends Mock
    implements GetApiCharacteresUsecase {}

class PaginationManagerMock extends Mock implements PaginationManager {}

// Classe Fake para CharactersSearchInput
class FakeCharactersSearchInput extends Fake implements CharactersSearchInput {}

void main() {
  group(
    'Tests in CharactersController',
    () {
      late GetApiCharacteresUsecase usecase;
      late PaginationManager paginationManager;
      late CharactersController controller;

      setUp(() {
        usecase = GetApiCharacteresUsecaseMock();
        paginationManager = PaginationManagerMock();
        controller = CharactersController(
          getApiCharacteresUsecase: usecase,
          paginationManager: paginationManager,
        );
      });

      setUpAll(() {
        registerFallbackValue(FakeCharactersSearchInput()); // Registre a fake
      });

      test(
        'Initial state is LoadingCharactersState',
        () async {
          expect(controller.value, isA<LoadingCharactersState>());
        },
      );

      test(
        'Should load characters data successfully',
        () async {
          when(() => paginationManager.page).thenReturn(1);
          when(() => usecase.call(any())).thenAnswer(
            (_) async => Success(resultCharacterReturnModel),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());
          final state = controller.value as SuccessCharactersState;
          expect(state.characterReturnEntity, resultCharacterReturnModel);
          verify(() => paginationManager.reset()).called(1);
          verify(() => paginationManager.nextPage()).called(1);
        },
      );
    },
  );
}

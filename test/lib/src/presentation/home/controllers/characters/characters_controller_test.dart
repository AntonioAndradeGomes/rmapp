import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/dependencies/dependencies_injector_imports.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';
import 'package:rmapp/src/domain/character/entities/enums.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';

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

      test(
        'Character data must be loaded with error',
        () async {
          final err = CustomException(
            code: '11',
            customMessage: 'custom message',
            messageError: 'message error',
          );
          when(() => paginationManager.page).thenReturn(1);
          when(() => usecase.call(any())).thenAnswer(
            (_) async => Failure(err),
          );
          await controller.loadData();
          expect(controller.value, isA<ErrorCharactersState>());
          final error = controller.value as ErrorCharactersState;
          expect(error.customException, err);
        },
      );

      test(
        'Should load more items when at the end of the list',
        () async {
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());

          when(() => paginationManager.page).thenReturn(2);
          when(() => paginationManager.hasMoreItems).thenReturn(true);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel2),
          );

          await controller.loadMoreItens();

          expect(controller.value, isA<SuccessCharactersState>());
          final state = controller.value as SuccessCharactersState;
          expect(
            state.characterReturnEntity?.results.length,
            resultCharacterReturnModel.results.length * 2,
          );
        },
      );

      test(
        'Should stop loading when there are no more items to load (info.next is null)',
        () async {
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel3),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());
          when(() => paginationManager.page).thenReturn(2);
          when(() => paginationManager.hasMoreItems).thenReturn(true);

          await controller.loadMoreItens();
          expect(controller.value, isA<SuccessCharactersState>());
          expect(controller.loadingMore.value, false);
          final state = controller.value as SuccessCharactersState;
          expect(
            state.characterReturnEntity?.results.length,
            resultCharacterReturnModel3.results.length,
          );
          verify(() => usecase.call(any())).called(1);
        },
      );

      test(
        'Should return an error when loadMoreItens fails',
        () async {
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());

          when(() => paginationManager.page).thenReturn(2);
          when(() => paginationManager.hasMoreItems).thenReturn(true);
          final err = CustomException(
            code: '111',
            customMessage: 'custom messsage',
            messageError: 'messsage Error',
          );
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Failure(err),
          );

          await controller.loadMoreItens();
          expect(controller.value, isA<ErrorCharactersState>());
          final state = controller.value as ErrorCharactersState;

          expect(state.customException, err);
        },
      );

      test(
        'Should return a list of items after text search',
        () async {
          final text = 'teste de busca';
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());

          var state = controller.value as SuccessCharactersState;
          expect(state.characterReturnEntity, resultCharacterReturnModel);
          expect(controller.search, '');
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel4),
          );

          await controller.onSearchByText(text);
          expect(controller.value, isA<SuccessCharactersState>());
          state = controller.value as SuccessCharactersState;
          expect(state.characterReturnEntity?.results.length, 1);
          expect(controller.search, text);
        },
      );

      test(
        'Should return a list of items after searching by filters',
        () async {
          final filter = FilterCharacter(
            genderEnum: GenderEnum.female,
            specieEnum: SpecieEnum.human,
            statusEnum: StatusEnum.dead,
          );
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel),
          );

          await controller.loadData();

          expect(controller.value, isA<SuccessCharactersState>());
          expect(controller.filter, FilterCharacter());
          when(() => paginationManager.page).thenReturn(1);
          when(
            () => usecase.call(any()),
          ).thenAnswer(
            (_) async => Success(resultCharacterReturnModel4),
          );

          await controller.onFilter(filter);
          expect(controller.value, isA<SuccessCharactersState>());
          final state = controller.value as SuccessCharactersState;
          expect(state.characterReturnEntity?.results.length, 1);
          expect(controller.filter, filter);
        },
      );
    },
  );
}

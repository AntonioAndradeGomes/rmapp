import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/dependencies/dependencies_injector_imports.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_state.dart';

import '../../../../../mocks.dart';

class GetCharacteresFromUrlsUsecaseMock extends Mock
    implements GetCharacteresFromUrlsUsecase {}

void main() {
  group(
    'Tests in ListCharacteresController',
    () {
      late GetCharacteresFromUrlsUsecase usecase;

      late ListCharacteresController controller;

      setUp(() {
        usecase = GetCharacteresFromUrlsUsecaseMock();
        controller = ListCharacteresController(
          getCharacteresFromUrlsUsecase: usecase,
        );
      });

      test('should return the initial loading state', () async {
        expect(controller.value, isA<LoadingListCharacteresState>());
      });

      test(
        'Should change to SuccessListCharacteresState when usecase returns success',
        () async {
          when(() => usecase.call(any())).thenAnswer(
            (_) async => Success(characterListMock),
          );
          await controller.loadData(
            urls: charactersUrlsMock,
          );

          expect(controller.value, isA<SuccessListCharacteresState>());
          final state = controller.value as SuccessListCharacteresState;
          expect(state.characteres!.length, characterListMock.length);
        },
      );

      test(
        'Should return error status',
        () async {
          when(() => usecase.call(any())).thenAnswer(
            (_) async => Failure(
              CustomException(
                code: '123',
                customMessage: 'Error test',
                messageError: 'Message error test',
              ),
            ),
          );

          await controller.loadData(
            urls: charactersUrlsMock,
          );
          expect(controller.value, isA<ErrorListCharacteresState>());
          final state = controller.value as ErrorListCharacteresState;
          expect(state.exception!.code, '123');
          expect(state.exception!.customMessage, 'Error test');
          expect(state.exception!.messageError, 'Message error test');
        },
      );
    },
  );
}

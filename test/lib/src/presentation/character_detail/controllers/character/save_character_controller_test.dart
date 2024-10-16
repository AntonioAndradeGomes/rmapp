import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/dependencies/dependencies_injector_imports.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/character/save_character_controller.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/character/save_character_state.dart';
import '../../../../../../mocks.dart';

class SaveCharacterUsecaseMock extends Mock implements SaveCharacterUsecase {}

void main() {
  group(
    'Tests in SaveCharacterController',
    () {
      late SaveCharacterUsecase usecase;
      late SaveCharacterController controller;

      setUp(
        () {
          usecase = SaveCharacterUsecaseMock();
          controller = SaveCharacterController(
            saveCharacterUsecase: usecase,
          );
        },
      );

      test(
        'It should return the initial state',
        () async {
          expect(controller.value, isA<InitialSaveCharacterState>());
        },
      );

      test(
        'Must save a character and return success',
        () async {
          when(() => usecase.call(characterListMock.first))
              .thenAnswer((_) async => Success(NoParams()));

          await controller.saveData(
            entity: characterListMock.first,
          );

          expect(controller.value, isA<SuccessSaveCharacterState>());
        },
      );

      test(
        'Should return an error',
        () async {
          when(() => usecase.call(characterListMock.first)).thenAnswer(
            (_) async => Failure(
              CustomException(
                code: '123',
                customMessage: 'Error test',
                messageError: 'Message error test',
              ),
            ),
          );

          await controller.saveData(
            entity: characterListMock.first,
          );

          expect(controller.value, isA<ErrorSaveCharacterState>());

          expect(controller.value.props.first, isA<CustomException>());
        },
      );
    },
  );
}

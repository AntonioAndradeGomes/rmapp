import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/character/usecases/save_character_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/character/save_character_state.dart';

class SaveCharacterController extends ValueNotifier<SaveCharacterState> {
  final SaveCharacterUsecase _saveCharacterUsecase;

  SaveCharacterController({
    required SaveCharacterUsecase saveCharacterUsecase,
  })  : _saveCharacterUsecase = saveCharacterUsecase,
        super(
          InitialSaveCharacterState(),
        );

  Future<void> saveData({required CharacterEntity entity}) async {
    value = LoadingSaveCharacterState();
    final result = await _saveCharacterUsecase(entity);
    result.fold(
      (success) {
        value = SuccessSaveCharacterState();
      },
      (error) {
        value = ErrorSaveCharacterState(error);
      },
    );
  }
}

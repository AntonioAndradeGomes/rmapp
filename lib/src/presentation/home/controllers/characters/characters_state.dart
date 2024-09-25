import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/character/entities/character_return_entity.dart';

sealed class CharactersState extends Equatable {
  final CharacterReturnEntity? characterReturnEntity;

  final CustomException? customException;

  const CharactersState({
    this.characterReturnEntity,
    this.customException,
  });

  @override
  List<Object?> get props => [
        characterReturnEntity,
        customException,
      ];
}

class LoadingCharactersState extends CharactersState {}

class SuccessCharactersState extends CharactersState {
  const SuccessCharactersState(CharacterReturnEntity characterReturnEntity)
      : super(
          characterReturnEntity: characterReturnEntity,
        );
}

class ErrorCharactersState extends CharactersState {
  const ErrorCharactersState(CustomException customException)
      : super(
          customException: customException,
        );
}

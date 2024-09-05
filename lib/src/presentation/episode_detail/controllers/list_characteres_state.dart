import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';

class ListCharacteresState extends Equatable {
  final List<CharacterEntity>? characteres;
  final CustomException? exception;

  const ListCharacteresState({
    this.characteres,
    this.exception,
  });

  @override
  List<Object?> get props => [
        characteres,
        exception,
      ];
}

class LoadingListCharacteresState extends ListCharacteresState {}

class SuccessListCharacteresState extends ListCharacteresState {
  const SuccessListCharacteresState(
    List<CharacterEntity> characteres,
  ) : super(
          characteres: characteres,
        );
}

class ErrorListCharacteresState extends ListCharacteresState {
  const ErrorListCharacteresState(
    CustomException exception,
  ) : super(
          exception: exception,
        );
}

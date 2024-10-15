import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';

sealed class SaveCharacterState extends Equatable {
  final CustomException? exception;

  const SaveCharacterState({
    this.exception,
  });

  @override
  List<Object?> get props => [exception];
}

class InitialSaveCharacterState extends SaveCharacterState {}

class LoadingSaveCharacterState extends SaveCharacterState {}

class SuccessSaveCharacterState extends SaveCharacterState {}

class ErrorSaveCharacterState extends SaveCharacterState {
  const ErrorSaveCharacterState(
    CustomException customException,
  ) : super(
          exception: customException,
        );
}

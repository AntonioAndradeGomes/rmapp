import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';

sealed class FavoritesState extends Equatable {
  final List<CharacterEntity>? characteres;
  final CustomException? exception;

  const FavoritesState({
    this.characteres,
    this.exception,
  });

  @override
  List<Object?> get props => [
        characteres,
        exception,
      ];
}

class LoadingFavoritesState extends FavoritesState {}

class SuccessFavoritesState extends FavoritesState {
  const SuccessFavoritesState(
    List<CharacterEntity> characteres,
  ) : super(
          characteres: characteres,
        );
}

class ErrorFavoritesState extends FavoritesState {
  const ErrorFavoritesState(
    CustomException exception,
  ) : super(
          exception: exception,
        );
}

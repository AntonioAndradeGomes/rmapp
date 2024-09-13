import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/usecases/get_favorites_characteres_usecase.dart';
import 'package:rmapp/src/domain/usecases/remove_character_favorite_usecase.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_state.dart';

class FavoritesController extends ValueNotifier<FavoritesState> {
  final GetFavoritesCharacteresUseCase _getFavoritesCharacteresUseCase;
  final RemoveCharacterFavoriteUsecase _removeCharactereFavoriteUsecase;

  FavoritesController()
      : _getFavoritesCharacteresUseCase =
            getIt<GetFavoritesCharacteresUseCase>(),
        _removeCharactereFavoriteUsecase =
            getIt<RemoveCharacterFavoriteUsecase>(),
        super(
          LoadingFavoritesState(),
        );

  Future<void> loadData() async {
    value = LoadingFavoritesState();
    final result = await _getFavoritesCharacteresUseCase(NoParams());
    result.fold(
      (success) {
        value = SuccessFavoritesState(success);
      },
      (err) {
        value = ErrorFavoritesState(err);
      },
    );
  }

  Future<void> removeCharacter(CharacterEntity entity) async {
    final result = await _removeCharactereFavoriteUsecase(entity);

    result.fold(
      (success) {
        final list = List<CharacterEntity>.from(value.characteres ?? []);
        list.removeWhere((item) => item.id == success);
        value = SuccessFavoritesState(list);
        return;
      },
      (error) {
        throw error;
      },
    );
  }
}

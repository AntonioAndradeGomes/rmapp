import 'package:flutter/material.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/usecases/get_favorites_characteres_usecase.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_state.dart';

class FavoritesController extends ValueNotifier<FavoritesState> {
  final GetFavoritesCharacteresUseCase _getFavoritesCharacteresUseCase;

  FavoritesController({
    required GetFavoritesCharacteresUseCase getFavoritesCharacteresUseCase,
  })  : _getFavoritesCharacteresUseCase = getFavoritesCharacteresUseCase,
        super(
          LoadingFavoritesState(),
        );

  Future<void> loadData() async {
    value = LoadingFavoritesState();
    final result = await _getFavoritesCharacteresUseCase.call(NoParams());
    result.fold(
      (success) {
        value = SuccessFavoritesState(success);
      },
      (err) {
        value = ErrorFavoritesState(err);
      },
    );
  }
}

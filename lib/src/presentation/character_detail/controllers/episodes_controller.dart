import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/episode/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/save_character_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_state.dart';

class EpisodesController extends ValueNotifier<EpisodesState> {
  final SaveCharacterUsecase _saveCharacterUsecase;
  final GetEpisodesFromUrlsUsecase _getEpisodesFromUrlsUsecase;
  EpisodesController({
    required GetEpisodesFromUrlsUsecase getEpisodesFromUrlsUsecase,
    required SaveCharacterUsecase saveCharacterUseCase,
  })  : _getEpisodesFromUrlsUsecase = getEpisodesFromUrlsUsecase,
        _saveCharacterUsecase = saveCharacterUseCase,
        super(LoadingEpisodesState());

  Future<void> loadData({
    required List<String> urls,
  }) async {
    value = LoadingEpisodesState();

    final result = await _getEpisodesFromUrlsUsecase(urls);
    result.fold(
      (success) {
        value = SuccessEpisodesState(success);
      },
      (error) {
        value = ErrorEpisodesState(error);
      },
    );
  }

  //remover isso depois quebra do single responsability
  Future<void> saveData({required CharacterEntity entity}) async {
    final result = await _saveCharacterUsecase(entity);
    result.fold(
      (success) {
        return;
      },
      (error) {
        throw error;
      },
    );
  }
}

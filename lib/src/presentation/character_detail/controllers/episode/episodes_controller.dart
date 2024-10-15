import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/episode/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episode/episodes_state.dart';

class EpisodesController extends ValueNotifier<EpisodesState> {
  final GetEpisodesFromUrlsUsecase _getEpisodesFromUrlsUsecase;
  EpisodesController({
    required GetEpisodesFromUrlsUsecase getEpisodesFromUrlsUsecase,
  })  : _getEpisodesFromUrlsUsecase = getEpisodesFromUrlsUsecase,
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
}

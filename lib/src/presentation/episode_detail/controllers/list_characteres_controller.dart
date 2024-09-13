import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/usecases/get_characteres_from_urls_usecase.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_state.dart';

class ListCharacteresController extends ValueNotifier<ListCharacteresState> {
  final GetCharacteresFromUrlsUsecase _getCharacteresFromUrlsUsecase;
  ListCharacteresController({
    required GetCharacteresFromUrlsUsecase getCharacteresFromUrlsUsecase,
  })  : _getCharacteresFromUrlsUsecase = getCharacteresFromUrlsUsecase,
        super(
          LoadingListCharacteresState(),
        );

  Future<void> loadData({
    required List<String> urls,
  }) async {
    value = LoadingListCharacteresState();
    final result = await _getCharacteresFromUrlsUsecase(urls);
    result.fold(
      (success) {
        value = SuccessListCharacteresState(success);
      },
      (error) {
        value = ErrorListCharacteresState(error);
      },
    );
  }
}

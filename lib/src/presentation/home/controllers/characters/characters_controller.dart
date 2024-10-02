import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';
import 'package:rmapp/src/domain/character/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';
import 'package:rmapp/src/domain/character/usecases/get_api_characteres_usecase.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/pagination_manager.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';

class CharactersController extends ValueNotifier<CharactersState> {
  final GetApiCharacteresUsecase _getApiCharacteresUsecase;
  final PaginationManager _paginationManager;
  final loadingMore = ValueNotifier<bool>(false);
  String search = '';
  FilterCharacter filter = FilterCharacter();

  CharactersController({
    required GetApiCharacteresUsecase getApiCharacteresUsecase,
    required PaginationManager paginationManager,
  })  : _getApiCharacteresUsecase = getApiCharacteresUsecase,
        _paginationManager = paginationManager,
        super(LoadingCharactersState());

  Future<void> loadData() async {
    value = LoadingCharactersState();
    _paginationManager.reset();
    loadingMore.value = false;

    final result = await _getApiCharacteresUsecase(
      CharactersSearchInput(
        page: _paginationManager.page,
        search: search,
        filterCharacter: filter,
      ),
    );
    result.fold(
      (success) {
        _paginationManager.nextPage();
        value = SuccessCharactersState(success);
      },
      (error) {
        value = ErrorCharactersState(error);
      },
    );
  }

  Future<void> loadMoreItens() async {
    if (!loadingMore.value && _paginationManager.hasMoreItems) {
      loadingMore.value = true;
      //validar se há próxima página
      final state = value.characterReturnEntity!;
      if (state.info.next == null) {
        loadingMore.value = false;
        _paginationManager.noMoreItems();
        return;
      }
      //buscar a próxima página
      final result = await _getApiCharacteresUsecase(
        CharactersSearchInput(
          page: _paginationManager.page,
          search: search,
          filterCharacter: filter,
        ),
      );

      result.fold(
        (success) {
          final entity = CharacterReturnEntity(
            info: success.info,
            results: state.results + success.results,
          );
          value = SuccessCharactersState(entity);
          loadingMore.value = false;
          _paginationManager.nextPage();
        },
        (error) {
          value = ErrorCharactersState(error);
        },
      );
    }
  }

  Future<void> onSearchByText(String value) async {
    search = value;
    loadData();
  }

  Future<void> onFilter(FilterCharacter value) async {
    filter = value;
    loadData();
  }
}

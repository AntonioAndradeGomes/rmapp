import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/caracter_search_input.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/usecases/get_api_characteres_usecase.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';

class CharactersController extends ValueNotifier<CharactersState> {
  final GetApiCharacteresUsecase _getApiCharacteresUsecase;
  late final ScrollController scrollController;
  int _page = 1;
  bool _haveItens = true;
  final loadingMore = ValueNotifier<bool>(false);
  String search = '';

  CharactersController({
    required GetApiCharacteresUsecase getApiCharacteresUsecase,
  })  : _getApiCharacteresUsecase = getApiCharacteresUsecase,
        super(LoadingCharactersState()) {
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  Future<void> loadData() async {
    value = LoadingCharactersState();
    _page = 1;
    loadingMore.value = false;
    _haveItens = true;
    final result = await _getApiCharacteresUsecase.call(
      CaracterSearchInput(
        page: _page,
        search: search,
      ),
    );
    result.fold(
      (success) {
        _page++;
        value = SuccessCharactersState(success);
      },
      (error) {
        value = ErrorCharactersState(error);
      },
    );
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent) {
      loadMoreItens();
    }
  }

  Future<void> loadMoreItens() async {
    if (!loadingMore.value && _haveItens) {
      loadingMore.value = true;
      //validar se há próxima página
      final state = value.characterReturnEntity!;
      if (state.info.next == null) {
        loadingMore.value = false;
        _haveItens = false;
        return;
      }
      //buscar a próxima página
      final result = await _getApiCharacteresUsecase.call(
        CaracterSearchInput(
          page: _page,
          search: search,
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
          _haveItens = true;
          _page++;
        },
        (error) {
          value = ErrorCharactersState(error);
        },
      );
    }
  }

  Future<void> onFilter(String value) async {
    search = value;
    loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

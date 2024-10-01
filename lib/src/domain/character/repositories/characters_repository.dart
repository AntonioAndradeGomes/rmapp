import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/character/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';

abstract interface class CharactersRepository {
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    CharactersSearchInput search,
  );

  Future<Result<List<CharacterEntity>, CustomException>> getCharactersFromUrls(
    List<String> urls,
  );

  Future<Result<NoParams, CustomException>> saveCharactersInLocalStorage(
    CharacterEntity entity,
  );

  Future<Result<List<CharacterEntity>, CustomException>>
      getCharactersFavorites();

  Future<Result<int, CustomException>> removeCharacterInLocalStorage(
    CharacterEntity entity,
  );
}

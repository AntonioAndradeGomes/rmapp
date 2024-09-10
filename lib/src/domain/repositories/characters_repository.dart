import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';

abstract interface class CharactersRepository {
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    int page,
    String search,
  );

  Future<Result<List<EpisodeEntity>, CustomException>> getEpisodesFromUrls(
    List<String> urls,
  );

  Future<Result<List<CharacterEntity>, CustomException>> getCharactersFromUrls(
    List<String> urls,
  );

  Future<Result<NoParams, CustomException>> saveCharactersInLocalStorage(
    CharacterEntity entity,
  );

  Future<Result<List<CharacterEntity>, CustomException>>
      getCharactersFavorites();
}

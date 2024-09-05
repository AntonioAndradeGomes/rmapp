import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/data/datasource/character_datasource.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterDatasource _datasource;

  CharactersRepositoryImpl({
    required CharacterDatasource datasource,
  }) : _datasource = datasource;
  @override
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    int page,
    String search,
  ) async {
    try {
      final characterReturnModel =
          await _datasource.getCharacters(page, search);
      return Success(characterReturnModel);
    } on CustomException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        CustomException(
          messageError: e.toString(),
          customMessage: 'An unexpected error has occurred. Please try again.',
        ),
      );
    }
  }

  @override
  Future<Result<List<EpisodeEntity>, CustomException>> getEpisodesFromUrls(
    List<String> urls,
  ) async {
    try {
      final episodes = await _datasource.getEpisodeFromUrls(urls);
      return Success(episodes);
    } catch (e) {
      return Failure(
        CustomException(
          messageError: e.toString(),
          customMessage:
              'An unexpected error occurred while fetching the episodes. Please try again.',
        ),
      );
    }
  }
}

import 'dart:developer';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/data/datasource/dao/character_dao.dart';
import 'package:rmapp/src/data/datasource/remote/character_datasource.dart';
import 'package:rmapp/src/data/models/character_model.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterDao _characterDao;
  final CharacterDatasource _datasource;

  CharactersRepositoryImpl({
    required CharacterDatasource datasource,
    required CharacterDao characterDao,
  })  : _datasource = datasource,
        _characterDao = characterDao;
  @override
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    int page,
    String search,
  ) async {
    try {
      final characterReturnModel =
          await _datasource.getCharacters(page, search);
      return characterReturnModel.toSuccess();
    } catch (e) {
      return CustomException(
        messageError: e.toString(),
        customMessage: 'An unexpected error has occurred. Please try again.',
      ).toFailure();
    }
  }

  @override
  Future<Result<List<EpisodeEntity>, CustomException>> getEpisodesFromUrls(
    List<String> urls,
  ) async {
    try {
      final episodes = await _datasource.getEpisodeFromUrls(urls);
      return episodes.toSuccess();
    } catch (e) {
      return CustomException(
        messageError: e.toString(),
        customMessage:
            'An unexpected error occurred while fetching the episodes. Please try again.',
      ).toFailure();
    }
  }

  @override
  Future<Result<List<CharacterEntity>, CustomException>> getCharactersFromUrls(
    List<String> urls,
  ) async {
    try {
      final characters = await _datasource.getCharactersFromUrl(urls);
      return Success(characters);
    } catch (e) {
      return Failure(
        CustomException(
          messageError: e.toString(),
          customMessage:
              'An unexpected error occurred while fetching the characteres. Please try again.',
        ),
      );
    }
  }

  @override
  Future<Result<NoParams, CustomException>> saveCharactersInLocalStorage(
    CharacterEntity entity,
  ) async {
    try {
      // Buscar o personagem no banco de dados pelo ID
      final existingCharacter =
          await _characterDao.findCharacterById(entity.id);
      // Verifica se o personagem existe no banco de dados
      if (existingCharacter != null) {
        log('Existe um character com o id fornecido');

        final isExactMath = await _characterDao.findCharacterByFullDetails(
          entity.id,
          entity.name,
          entity.status,
          entity.species,
          entity.type,
          entity.gender,
          entity.locationName,
          entity.episodes,
          entity.image,
        );

        // Verifica se o personagem é exatamente o mesmo comparando todos os campos
        if (isExactMath == null) {
          log('O Character existente com o id fornecido não exatamente igual a um existente então atualizarei');
          // Se os dados forem diferentes, atualizar o personagem
          await _characterDao.updateCharacter(
            CharacterModel.fromEntity(entity),
          );
          return NoParams().toSuccess();
        }
        log(' o personagem já está entre os favoritos com dados iguais');
        // Se o personagem já está entre os favoritos com dados iguais
        return const CustomException(
          customMessage: 'Character is already a favorite',
          code: '1555',
        ).toFailure();
      }
      log('o personagem não existe no banco');
      // Se o personagem não existir no banco, adicionar
      await _characterDao.insertCharacter(
        CharacterModel.fromEntity(entity),
      );
      return NoParams().toSuccess();
    } catch (e, s) {
      log(
        'saveCharactersInLocalStorage error: ${e.toString()}',
        stackTrace: s,
        error: e,
      );
      return CustomException(
        messageError: e.toString(),
        customMessage: 'Unable to add',
      ).toFailure();
    }
  }

  @override
  Future<Result<List<CharacterEntity>, CustomException>>
      getCharactersFavorites() async {
    try {
      final result = await _characterDao.getAll();
      return result.toSuccess();
    } catch (e) {
      return const CustomException(
        customMessage: 'Error fetching favorite characters. Try again!',
      ).toFailure();
    }
  }

  @override
  Future<Result<int, CustomException>> removeCharacterInLocalStorage(
    CharacterEntity entity,
  ) async {
    try {
      await _characterDao.deleteCharacter(
        CharacterModel.fromEntity(entity),
      );
      return entity.id.toSuccess();
    } catch (e) {
      return const CustomException(
        customMessage: 'Unable to remove character. Try again!',
      ).toFailure();
    }
  }
}

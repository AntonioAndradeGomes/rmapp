import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/data/character/datasources/dao/character_dao.dart';
import 'package:rmapp/src/data/character/datasources/remote/character_datasource.dart';
import 'package:rmapp/src/data/character/models/character_model.dart';
import 'package:rmapp/src/data/character/models/characters_search_input_model.dart';
import 'package:rmapp/src/data/character/repositories/characters_repository_impl.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/character/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/character/entities/characters_search_input.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';
import 'package:rmapp/src/domain/character/repositories/characters_repository.dart';

import '../../../../../mocks.dart';

class CharacterDaoMock extends Mock implements CharacterDao {}

class CharacterDatasourceMock extends Mock implements CharacterDatasource {}

void main() {
  group(
    'Tests in CharactersRepository',
    () {
      late CharacterDao dao;
      late CharacterDatasource datasource;
      late CharactersRepository repository;

      setUp(() {
        dao = CharacterDaoMock();
        datasource = CharacterDatasourceMock();
        repository = CharactersRepositoryImpl(
          datasource: datasource,
          characterDao: dao,
        );
      });

      group(
        'Tests in function getCaractersFromApi',
        () {
          const search = CharactersSearchInput(
            page: 1,
            search: '',
            filterCharacter: FilterCharacter(),
          );

          final searchModel = CharactersSearchInputModel.fromEntity(search);
          test(
            'Should return CharacterReturnEntity',
            () async {
              when(
                () => datasource.getCharacters(
                  searchModel,
                ),
              ).thenAnswer(
                (_) async => resultCharacterReturnModel,
              );

              final test = await repository.getCaractersFromApi(search);

              expect(test.isSuccess(), true);
              expect(test.isError(), false);
              expect(test.getOrNull(), isA<CharacterReturnEntity>());
              expect(test.getOrNull()!.info,
                  equals(resultCharacterReturnModel.info));
              expect(test.getOrNull()!.results.length, 5);
              verify(() => datasource.getCharacters(searchModel)).called(1);
            },
          );

          test(
            'Should return a failure',
            () async {
              when(
                () => datasource.getCharacters(searchModel),
              ).thenThrow(
                (_) async => Exception(),
              );

              final test = await repository.getCaractersFromApi(search);

              expect(test.isSuccess(), false);
              expect(test.isError(), true);
              expect(test.exceptionOrNull(), isA<CustomException>());
            },
          );
        },
      );

      group(
        'Tests in getCharactersFromUrls',
        () {
          test(
            'should return an List CharacterEntity',
            () async {
              when(
                () => datasource.getCharactersFromUrl(charactersUrlsMock),
              ).thenAnswer(
                (_) async => characterListMock,
              );
              final test =
                  await repository.getCharactersFromUrls(charactersUrlsMock);
              expect(test.isSuccess(), true);
              expect(test.isError(), false);
              expect(test.getOrNull(), isA<List<CharacterEntity>>());
            },
          );

          test(
            'should return a failure when an exception occurs',
            () async {
              when(
                () => datasource.getEpisodeFromUrls(charactersUrlsMock),
              ).thenThrow(
                (_) async => Exception(
                  'Error fetching episodes',
                ),
              );

              final test =
                  await repository.getCharactersFromUrls(charactersUrlsMock);
              expect(test.isSuccess(), false);
              expect(test.isError(), true);
            },
          );
        },
      );

      group(
        'Tests in saveCharactersInLocalStorage',
        () {
          //personagem não existe no banco de dados
          test(
            'should insert character if not found in database',
            () async {
              final characterEntity = characterListMock.first;

              // Simulando a resposta para findCharacterById
              when(() => dao.findCharacterById(characterEntity.id))
                  .thenAnswer((_) async => null);

              // Simulando a resposta para insertCharacter (precisa retornar um ID)
              final model = CharacterModel.fromEntity(characterEntity);
              when(
                () => dao.insertCharacter(model),
              ).thenAnswer(
                (_) async => characterEntity.id,
              );

              final result = await repository.saveCharactersInLocalStorage(
                characterEntity,
              );

              expect(result.isSuccess(), true);
              expect(result.getOrNull(), isA<NoParams>());
              // Verificar se o findCharacterById foi chamado
              verify(() => dao.findCharacterById(model.id)).called(1);

              // Verificar se o insertCharacter foi chamado
              verify(() => dao.insertCharacter(model)).called(1);
            },
          );
          //o personagem existe no banco de dados com os mesmos dados
          test(
            'should return failure if character already exists with identical data',
            () async {
              final characterEntity = characterListMock.first;
              final model = CharacterModel.fromEntity(characterEntity);
              // Simulando a resposta para findCharacterById
              when(() => dao.findCharacterById(characterEntity.id)).thenAnswer(
                (_) async => model,
              );
              when(
                () => dao.findCharacterByFullDetails(
                  characterEntity.id,
                  characterEntity.name,
                  characterEntity.status,
                  characterEntity.species,
                  characterEntity.type,
                  characterEntity.gender,
                  characterEntity.locationName,
                  characterEntity.episodes,
                  characterEntity.image,
                ),
              ).thenAnswer((_) async => model);
              // Act: Tentar salvar personagem
              final result = await repository
                  .saveCharactersInLocalStorage(characterEntity);

              expect(result.isError(), true);
              expect(result.exceptionOrNull(), isA<CustomException>());
              expect(
                result.exceptionOrNull()?.code,
                '1555',
              );
              expect(
                result.exceptionOrNull()?.customMessage,
                'Character is already a favorite',
              );
              verifyNever(() => dao.updateCharacter(model));
            },
          );

          //existe o id do personagem com dados diferentes
          test(
            'should update character if data is different',
            () async {
              final characterEntity = characterListMock.first;
              final model = CharacterModel.fromEntity(characterEntity);
              // Simulando a resposta para findCharacterById
              when(() => dao.findCharacterById(characterEntity.id)).thenAnswer(
                (_) async => model,
              );
              when(
                () => dao.findCharacterByFullDetails(
                  characterEntity.id,
                  characterEntity.name,
                  characterEntity.status,
                  characterEntity.species,
                  characterEntity.type,
                  characterEntity.gender,
                  characterEntity.locationName,
                  characterEntity.episodes,
                  characterEntity.image,
                ),
              ).thenAnswer(
                (_) async => null,
              );
              when(() => dao.updateCharacter(model)).thenAnswer(
                (_) async => Future.value(),
              );
              final result = await repository
                  .saveCharactersInLocalStorage(characterEntity);
              expect(result.isSuccess(), true);
              expect(result.getOrNull(), isA<NoParams>());
              verify(() => dao.findCharacterById(model.id)).called(1);
              verify(
                () => dao.findCharacterByFullDetails(
                  characterEntity.id,
                  characterEntity.name,
                  characterEntity.status,
                  characterEntity.species,
                  characterEntity.type,
                  characterEntity.gender,
                  characterEntity.locationName,
                  characterEntity.episodes,
                  characterEntity.image,
                ),
              ).called(1);
              verify(() => dao.updateCharacter(model)).called(1);
            },
          );

          test(
            'should return failure if an exception is thrown',
            () async {
              final characterEntity = characterListMock.first;
              when(() => dao.findCharacterById(characterEntity.id))
                  .thenThrow(Exception('Database error'));
              final result = await repository
                  .saveCharactersInLocalStorage(characterEntity);
              expect(result.isError(), true);
              expect(
                result.exceptionOrNull()?.customMessage,
                'Unable to add',
              );
            },
          );
        },
      );

      group(
        'Tests in getCharactersFavorites',
        () {
          test(
            'should return a list of characters coming from local storage',
            () async {
              when(() => dao.getAll()).thenAnswer(
                (_) async => characterListMock,
              );

              final result = await repository.getCharactersFavorites();
              expect(result.isSuccess(), true);
              expect(result.getOrNull(), isA<List<CharacterEntity>>());
              expect(result.getOrNull()!.length, characterListMock.length);
            },
          );

          test(
            'should return an error when trying to list the characters',
            () async {
              when(() => dao.getAll()).thenThrow(Exception('Database error'));
              final result = await repository.getCharactersFavorites();
              expect(result.isSuccess(), false);
              expect(result.isError(), true);
              expect(
                result.exceptionOrNull()?.customMessage,
                'Error fetching favorite characters. Try again!',
              );
            },
          );
        },
      );

      group(
        'tests in removeCharacterInLocalStorage',
        () {
          test(
            'should return the id of the removed character',
            () async {
              final characterEntity = characterListMock.first;
              final model = CharacterModel.fromEntity(characterEntity);
              when(() => dao.deleteCharacter(model)).thenAnswer(
                (_) => Future.value(),
              );
              final result = await repository
                  .removeCharacterInLocalStorage(characterEntity);

              expect(result.isSuccess(), true);
              expect(result.getOrNull(), model.id);
              verify(() => dao.deleteCharacter(model)).called(1);
            },
          );

          test(
            'should return an error when trying to remove character',
            () async {
              final characterEntity = characterListMock.first;
              final model = CharacterModel.fromEntity(characterEntity);
              when(() => dao.deleteCharacter(model))
                  .thenThrow(Exception('Database error'));
              final result = await repository
                  .removeCharacterInLocalStorage(characterEntity);

              expect(result.isSuccess(), false);
              expect(result.isError(), true);
              expect(
                result.exceptionOrNull()?.customMessage,
                'Unable to remove character. Try again!',
              );
            },
          );
        },
      );
    },
  );
}

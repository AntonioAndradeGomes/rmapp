import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/data/datasource/dao/character_dao.dart';
import 'package:rmapp/src/data/datasource/remote/character_datasource.dart';
import 'package:rmapp/src/data/repositories/characters_repository_impl.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

import '../../../mocks.dart';

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
          test(
            'Should return CharacterReturnEntity',
            () async {
              when(
                () => datasource.getCharacters(
                  any(),
                  any(),
                ),
              ).thenAnswer(
                (_) async => resultCharacterReturnModel,
              );

              final test = await repository.getCaractersFromApi(
                1,
                '',
              );

              expect(test.isSuccess(), true);
              expect(test.isError(), false);
              expect(test.getOrNull(), isA<CharacterReturnEntity>());
              expect(test.getOrNull()!.info,
                  equals(resultCharacterReturnModel.info));
              expect(test.getOrNull()!.results.length, 5);
              verify(() => datasource.getCharacters(1, '')).called(1);
            },
          );

          test(
            'Should return a failure',
            () async {
              when(
                () => datasource.getCharacters(
                  any(),
                  any(),
                ),
              ).thenThrow(
                (_) async => Exception(),
              );

              final test = await repository.getCaractersFromApi(1, '');

              expect(test.isSuccess(), false);
              expect(test.isError(), true);
              expect(test.exceptionOrNull(), isA<CustomException>());
            },
          );
        },
      );

      group(
        'Tests in getEpisodesFromUrls',
        () {
          test(
            'should return an List EpisodeEntity',
            () async {
              when(
                () => datasource.getEpisodeFromUrls(episodesUrlsMock),
              ).thenAnswer(
                (_) async => mockEpisodeList,
              );
              final test =
                  await repository.getEpisodesFromUrls(episodesUrlsMock);
              expect(test.isSuccess(), true);
              expect(test.isError(), false);
              expect(test.getOrNull(), isA<List<EpisodeEntity>>());
            },
          );

          test(
            'should return a failure when an exception occurs',
            () async {
              when(
                () => datasource.getEpisodeFromUrls(episodesUrlsMock),
              ).thenThrow(
                (_) async => Exception(
                  'Error fetching episodes',
                ),
              );

              final test =
                  await repository.getEpisodesFromUrls(episodesUrlsMock);
              expect(test.isSuccess(), false);
              expect(test.isError(), true);
              expect(
                test.exceptionOrNull()?.customMessage,
                'An unexpected error occurred while fetching the episodes. Please try again.',
              );
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
    },
  );
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/data/episode/datasources/remote/episode_datasource.dart';
import 'package:rmapp/src/data/episode/repositories/episode_repository_impl.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/domain/episode/repositories/episode_repository.dart';

import '../../../../../mocks.dart';

class EpisodeDatasourceMock extends Mock implements EpisodeDatasource {}

void main() {
  group(
    'Tests in EpisodeRepository',
    () {
      late EpisodeDatasource datasource;
      late EpisodeRepository repository;

      setUp(() {
        datasource = EpisodeDatasourceMock();
        repository = EpisodeRepositoryImpl(
          datasource: datasource,
        );
      });

      group(
        'Tests in getEpisodesFromUrls',
        () {
          test(
            'should return an List EpisodeEntity',
            () async {
              when(
                () => datasource.getEpisodeFromUrls(
                  episodesUrlsMock,
                ),
              ).thenAnswer(
                (_) async => mockEpisodeList,
              );
              final test = await repository.getEpisodesFromUrls(
                episodesUrlsMock,
              );
              expect(test.isSuccess(), true);
              expect(test.isError(), false);
              expect(test.getOrNull(), isA<List<EpisodeEntity>>());
            },
          );

          test(
            'should return a failure when an exception occurs',
            () async {
              when(
                () => datasource.getEpisodeFromUrls(
                  episodesUrlsMock,
                ),
              ).thenThrow(
                (_) async => Exception(
                  'Error fetching episodes',
                ),
              );

              final test = await repository.getEpisodesFromUrls(
                episodesUrlsMock,
              );
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
    },
  );
}

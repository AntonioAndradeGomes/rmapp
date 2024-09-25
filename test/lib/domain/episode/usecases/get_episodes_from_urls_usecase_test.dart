import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/domain/episode/repositories/episode_repository.dart';
import 'package:rmapp/src/domain/episode/usecases/get_episodes_from_urls_usecase.dart';
import '../../../../mocks.dart';

void main() {
  group(
    'Tests in GetEpisodesFromUrlsUsecase',
    () {
      late EpisodeRepository repository;
      late GetEpisodesFromUrlsUsecase usecase;

      setUp(() {
        repository = EpisodesRepositoryMock();
        usecase = GetEpisodesFromUrlsUsecase(
          repository: repository,
        );
      });

      test(
        'Should return a list of Episodes',
        () async {
          when(
            () => repository.getEpisodesFromUrls(any()),
          ).thenAnswer(
            (_) async => const Success(mockEpisodeList),
          );

          final test = await usecase.call(
            [
              'https://rickandmortyapi.com/api/episode/1',
              'https://rickandmortyapi.com/api/episode/2',
              'https://rickandmortyapi.com/api/episode/3',
              'https://rickandmortyapi.com/api/episode/4',
              'https://rickandmortyapi.com/api/episode/5',
            ],
          );
          expect(test.isSuccess(), true);
          expect(test.isError(), false);
          expect(test.getOrNull(), isA<List<EpisodeEntity>>());
          expect(test.getOrNull()?.length ?? 0, 5);
        },
      );

      test(
        'Should return a CustomException',
        () async {
          when(
            () => repository.getEpisodesFromUrls(any()),
          ).thenAnswer(
            (_) async => const Failure(customExceptionMock),
          );

          final test = await usecase.call(
            [
              'https://rickandmortyapi.com/api/episode/1',
              'https://rickandmortyapi.com/api/episode/2',
              'https://rickandmortyapi.com/api/episode/3',
              'https://rickandmortyapi.com/api/episode/4',
              'https://rickandmortyapi.com/api/episode/5',
            ],
          );
          expect(test.isSuccess(), false);
          expect(test.isError(), true);
          expect(test.exceptionOrNull(), isA<CustomException>());
          expect(test.exceptionOrNull(), equals(customExceptionMock));
        },
      );
    },
  );
}

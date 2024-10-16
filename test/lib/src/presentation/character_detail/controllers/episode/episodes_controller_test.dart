import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/character/usecases/save_character_usecase.dart';
import 'package:rmapp/src/domain/episode/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episode/episodes_controller.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episode/episodes_state.dart';

import '../../../../../../mocks.dart';

class SaveCharacterUsecaseMock extends Mock implements SaveCharacterUsecase {}

class GetEpisodesFromUrlsUsecaseMock extends Mock
    implements GetEpisodesFromUrlsUsecase {}

void main() {
  group(
    'Tests in EpisodesController',
    () {
      late GetEpisodesFromUrlsUsecase getEpisodesFromUrlsUsecase;
      late EpisodesController controller;

      setUp(
        () {
          getEpisodesFromUrlsUsecase = GetEpisodesFromUrlsUsecaseMock();
          controller = EpisodesController(
            getEpisodesFromUrlsUsecase: getEpisodesFromUrlsUsecase,
          );
        },
      );

      test(
        'Test initial state',
        () async {
          final state = controller.value;
          expect(state, isA<LoadingEpisodesState>());
        },
      );

      test(
        'You must search for the episodes by passing the URLs',
        () async {
          when(() => getEpisodesFromUrlsUsecase.call(any())).thenAnswer(
            (_) async => Success(mockEpisodeList),
          );
          await controller.loadData(urls: episodesUrlsMock);
          expect(controller.value, isA<SuccessEpisodesState>());
        },
      );

      test(
        'Should return an error',
        () async {
          when(() => getEpisodesFromUrlsUsecase.call(any())).thenAnswer(
            (_) async => Failure(
              CustomException(
                code: '123',
                customMessage: 'Error test',
                messageError: 'Message error test',
              ),
            ),
          );
          await controller.loadData(urls: episodesUrlsMock);
          expect(controller.value, isA<ErrorEpisodesState>());
        },
      );
    },
  );
}

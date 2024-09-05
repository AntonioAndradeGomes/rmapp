import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rmapp/src/data/datasource/character_datasource.dart';
import 'package:rmapp/src/data/repositories/characters_repository_impl.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/usecases/get_api_characteres_usecase.dart';
import 'package:rmapp/src/domain/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_controller.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_controller.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt.registerSingleton(Dio());

  getIt.registerLazySingleton<CharacterDatasource>(
    () => CharacterDatasourceImpl(
      dio: getIt(),
    ),
  );

  getIt.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(
      datasource: getIt(),
    ),
  );

  getIt.registerLazySingleton<GetApiCharacteresUsecase>(
    () => GetApiCharacteresUsecase(
      repository: getIt(),
    ),
  );

  getIt.registerLazySingleton<GetEpisodesFromUrlsUsecase>(
    () => GetEpisodesFromUrlsUsecase(
      repository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => EpisodesController(
      getEpisodesFromUrlsUsecase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => CharactersController(
      getApiCharacteresUsecase: getIt(),
    ),
  );
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rmapp/src/common/database/app_database.dart';
import 'package:rmapp/src/data/datasource/dao/character_dao.dart';
import 'package:rmapp/src/data/datasource/remote/character_datasource.dart';
import 'package:rmapp/src/data/repositories/characters_repository_impl.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/usecases/get_api_characteres_usecase.dart';
import 'package:rmapp/src/domain/usecases/get_characteres_from_urls_usecase.dart';
import 'package:rmapp/src/domain/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/domain/usecases/get_favorites_characteres_usecase.dart';
import 'package:rmapp/src/domain/usecases/save_character_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_controller.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_controller.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_controller.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_controller.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  getIt.registerSingleton<CharacterDao>(database.characterDao);

  getIt.registerSingleton(Dio());

  getIt.registerLazySingleton<CharacterDatasource>(
    () => CharacterDatasourceImpl(
      dio: getIt(),
    ),
  );

  getIt.registerLazySingleton<CharactersRepository>(
    () => CharactersRepositoryImpl(
      datasource: getIt(),
      characterDao: getIt(),
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

  getIt.registerLazySingleton<GetCharacteresFromUrlsUsecase>(
    () => GetCharacteresFromUrlsUsecase(
      repository: getIt(),
    ),
  );

  getIt.registerLazySingleton<SaveCharacterUsecase>(
    () => SaveCharacterUsecase(
      repository: getIt(),
    ),
  );

  getIt.registerLazySingleton<GetFavoritesCharacteresUseCase>(
    () => GetFavoritesCharacteresUseCase(
      repository: getIt(),
    ),
  );

  getIt.registerFactory(
    () => EpisodesController(
      getEpisodesFromUrlsUsecase: getIt(),
      saveCharacterUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => CharactersController(
      getApiCharacteresUsecase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => ListCharacteresController(
      getCharacteresFromUrlsUsecase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => FavoritesController(
      getFavoritesCharacteresUseCase: getIt(),
    ),
  );
}

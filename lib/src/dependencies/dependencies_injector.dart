import 'package:dio/dio.dart';
import 'package:rmapp/src/common/database/app_database.dart';
import 'package:rmapp/src/data/character/datasources/dao/character_dao.dart';
import 'package:rmapp/src/data/character/datasources/remote/character_datasource.dart';
import 'package:rmapp/src/data/character/repositories/characters_repository_impl.dart';
import 'package:rmapp/src/data/episode/datasources/remote/episode_datasource.dart';
import 'package:rmapp/src/data/episode/repositories/episode_repository_impl.dart';
import 'package:rmapp/src/dependencies/injector.dart';
import 'package:rmapp/src/domain/character/repositories/characters_repository.dart';
import 'package:rmapp/src/domain/character/usecases/get_api_characteres_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/get_characteres_from_urls_usecase.dart';
import 'package:rmapp/src/domain/episode/repositories/episode_repository.dart';
import 'package:rmapp/src/domain/episode/usecases/get_episodes_from_urls_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/get_favorites_characteres_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/remove_character_favorite_usecase.dart';
import 'package:rmapp/src/domain/character/usecases/save_character_usecase.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_controller.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_controller.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_controller.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_controller.dart';

final injector = InjectorImp();

Future<void> initializeDependencies() async {
  // Inicialização do banco de dados
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  injector.registerSingleton<CharacterDao>(
    database.characterDao,
  );

  // Registros de serviços únicos
  injector.registerSingleton(
    Dio(),
  );

  // Lazy singletons para classes relacionadas à API e Repositórios
  injector
    ..registerLazySingleton<CharacterDatasource>(
      () => CharacterDatasourceImpl(
        dio: injector(),
      ),
    )
    ..registerLazySingleton<EpisodeDatasource>(
      () => EpisodeDatasourceImpl(
        dio: injector(),
      ),
    )
    ..registerLazySingleton<CharactersRepository>(
      () => CharactersRepositoryImpl(
        datasource: injector(),
        characterDao: injector(),
      ),
    )
    ..registerLazySingleton<EpisodeRepository>(
      () => EpisodeRepositoryImpl(
        datasource: injector(),
      ),
    );

  // Casos de uso
  injector
    ..registerLazySingleton<GetApiCharacteresUsecase>(
      () => GetApiCharacteresUsecase(
        repository: injector(),
      ),
    )
    ..registerLazySingleton<GetEpisodesFromUrlsUsecase>(
      () => GetEpisodesFromUrlsUsecase(
        repository: injector(),
      ),
    )
    ..registerLazySingleton<GetCharacteresFromUrlsUsecase>(
      () => GetCharacteresFromUrlsUsecase(
        repository: injector(),
      ),
    )
    ..registerLazySingleton<SaveCharacterUsecase>(
      () => SaveCharacterUsecase(
        repository: injector(),
      ),
    )
    ..registerLazySingleton<GetFavoritesCharacteresUseCase>(
      () => GetFavoritesCharacteresUseCase(
        repository: injector(),
      ),
    )
    ..registerLazySingleton<RemoveCharacterFavoriteUsecase>(
      () => RemoveCharacterFavoriteUsecase(
        repository: injector(),
      ),
    );

  // Controllers registrando na mesma linha para economizar chamadas ao injector
  injector
    ..registerFactory(
      () => EpisodesController(
        getEpisodesFromUrlsUsecase: injector(),
        saveCharacterUseCase: injector(),
      ),
    )
    ..registerFactory(
      () => CharactersController(
        getApiCharacteresUsecase: injector(),
      ),
    )
    ..registerFactory(
      () => ListCharacteresController(
        getCharacteresFromUrlsUsecase: injector(),
      ),
    )
    ..registerFactory(
      () => FavoritesController(),
    );
}

import 'package:rmapp/src/presentation/home/controllers/characters/pagination_manager.dart';

import './dependencies_injector_imports.dart';

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
      () => PaginationManager(),
    )
    ..registerFactory(
      () => CharactersController(
        getApiCharacteresUsecase: injector(),
        paginationManager: injector(),
      ),
    )
    ..registerFactory(
      () => ListCharacteresController(
        getCharacteresFromUrlsUsecase: injector(),
      ),
    )
    ..registerFactory(
      () => FavoritesController(
        getFavoritesCharacteresUseCase: injector(),
        removeCharactereFavoriteUsecase: injector(),
      ),
    )
    ..registerFactory(
      () => FilterController(),
    );
}

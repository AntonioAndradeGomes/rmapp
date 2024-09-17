//abstriando o package get_it de modo que eu precise mudar somente aqui caso o package mude

import 'package:get_it/get_it.dart';

abstract class Injector<T extends Object> {
  void registerSingleton<T extends Object>(T instance);
  void registerLazySingleton<T extends Object>(T Function() instance);
  void registerFactory<T extends Object>(T Function() instance);

  T get<T extends Object>();
  T call<T extends Object>();
}

class InjectorImp<T extends Object> implements Injector<T> {
  final _getIt = GetIt.instance;

  @override
  void registerFactory<T extends Object>(T Function() instance) {
    _getIt.registerFactory(() => instance());
  }

  @override
  void registerLazySingleton<T extends Object>(T Function() instance) {
    _getIt.registerLazySingleton(() => instance());
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  T call<T extends Object>() {
    return _getIt<T>();
  }

  @override
  T get<T extends Object>() {
    return _getIt<T>();
  }
}

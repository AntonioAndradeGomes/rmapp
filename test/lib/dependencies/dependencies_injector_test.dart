import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/dependencies/injector.dart';

class MockGetIt extends Mock implements GetIt {}

class ExampleClass extends Equatable {
  @override
  List<Object?> get props => [];
}

void main() {
  group(
    'Tests in InjectorImp',
    () {
      late GetIt getIt;
      late Injector injector;

      setUp(() {
        getIt = MockGetIt();
        injector = InjectorImp(
          getIt: getIt,
        );
      });
      test(
        'Must register a Singleton',
        () async {
          final instance = ExampleClass();
          when(() => getIt.registerSingleton<ExampleClass>(instance))
              .thenAnswer(
            (_) => instance,
          );

          injector.registerSingleton<ExampleClass>(instance);
          verify(() => getIt.registerSingleton<ExampleClass>(instance))
              .called(1);
        },
      );

      test(
        'Must register a lazy singleton',
        () async {
          final instance = ExampleClass();
          when(() => getIt.registerLazySingleton<ExampleClass>(any()))
              .thenAnswer(
            (_) => {},
          );

          injector.registerLazySingleton<ExampleClass>(() => instance);
          verify(() => getIt.registerLazySingleton<ExampleClass>(any()))
              .called(1);
        },
      );

      test(
        'Must register factory',
        () {
          final instance = ExampleClass();

          when(() => getIt.registerFactory<ExampleClass>(any()))
              .thenAnswer((_) => {});

          injector.registerFactory<ExampleClass>(() => instance);

          verify(() => getIt.registerFactory<ExampleClass>(any())).called(1);
        },
      );

      test(
        'Must get dependency registered',
        () {
          final instance = ExampleClass();

          when(() => getIt<ExampleClass>()).thenReturn(instance);

          final result = injector.get<ExampleClass>();

          expect(result, instance);
          verify(() => getIt<ExampleClass>()).called(1);
        },
      );

      test(
        'Must get dependency registered with call',
        () {
          final instance = ExampleClass();
          when(() => getIt<ExampleClass>()).thenReturn(instance);

          final result = injector.call<ExampleClass>();
          expect(result, instance);
          verify(() => getIt<ExampleClass>()).called(1);
        },
      );
    },
  );
}

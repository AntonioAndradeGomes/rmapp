import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/data/episode/datasources/remote/episode_datasource.dart';

import '../../../../../../mocks.dart';

void main() {
  group(
    'Tests in EpisodeDatasource',
    () {
      late Dio dio;
      late EpisodeDatasource datasource;

      setUp(() {
        dio = MockDio();
        datasource = EpisodeDatasourceImpl(
          dio: dio,
        );
      });

      setUpAll(() {
        registerFallbackValue(RequestOptions(path: ''));
      });

      group(
        'Tests in getEpisodeFromUrls',
        () {
          test(
            'Should return a list of episodes',
            () async {
              when(() => dio.get(episodesUrlsMock[0])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[0],
                  ),
                  data: mockEpisodeList[0].toJson(),
                  statusCode: 200,
                ),
              );
              when(() => dio.get(episodesUrlsMock[1])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[1],
                  ),
                  data: mockEpisodeList[1].toJson(),
                  statusCode: 200,
                ),
              );
              when(() => dio.get(episodesUrlsMock[2])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[2],
                  ),
                  data: mockEpisodeList[2].toJson(),
                  statusCode: 200,
                ),
              );

              final result = await datasource.getEpisodeFromUrls(
                episodesUrlsMock.sublist(0, 3),
              );

              expect(result.length, 3);
              expect(
                result,
                mockEpisodeList.sublist(0, 3),
              );
            },
          );

          test(
            'should throw an exception when DioException occurs',
            () async {
              when(() => dio.get(episodesUrlsMock[0])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[0],
                  ),
                  data: mockEpisodeList[0].toJson(),
                  statusCode: 200,
                ),
              );
              when(() => dio.get(episodesUrlsMock[1])).thenThrow(
                DioException(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[1],
                  ),
                  response: null,
                  message: 'Exception',
                ),
              );
              when(() => dio.get(episodesUrlsMock[2])).thenThrow(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: episodesUrlsMock[2],
                  ),
                  data: mockEpisodeList[2].toJson(),
                  statusCode: 200,
                ),
              );
              expect(
                () async => await datasource.getEpisodeFromUrls(
                  episodesUrlsMock.sublist(0, 3),
                ),
                throwsA(
                  isA<Exception>().having(
                    (e) => e.toString(),
                    'Error message',
                    contains(
                      'Failed to fetch episodes: Exception',
                    ),
                  ),
                ),
              );
              verify(() => dio.get(episodesUrlsMock[0])).called(1);
              verify(() => dio.get(episodesUrlsMock[1])).called(1);
              verifyNever(() => dio.get(episodesUrlsMock[2]));
            },
          );

          test(
            'Should throw an unknown error',
            () async {
              when(
                () => dio.get(
                  episodesUrlsMock[0],
                ),
              ).thenThrow(
                Exception(
                  'Unexpected error',
                ),
              );

              expect(
                () async => await datasource.getEpisodeFromUrls(
                  episodesUrlsMock.sublist(0, 3),
                ),
                throwsA(
                  isA<Exception>().having(
                    (e) => e.toString(),
                    'Error message',
                    contains(
                      'Failed to fetch episodes, an unknown error occurred',
                    ),
                  ),
                ),
              );
              verify(() => dio.get(episodesUrlsMock[0])).called(1);
              verifyNever(() => dio.get(episodesUrlsMock[1]));
              verifyNever(() => dio.get(episodesUrlsMock[2]));
            },
          );
        },
      );
    },
  );
}

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/common/constants/urls.dart';
import 'package:rmapp/src/data/character/datasources/remote/character_datasource.dart';
import 'package:rmapp/src/data/character/models/character_return_model.dart';

import '../../../../../../mocks.dart';

void main() {
  group(
    'Tests in CharacterDatasource',
    () {
      late Dio dio;
      late CharacterDatasource datasource;

      setUp(() {
        dio = MockDio();
        datasource = CharacterDatasourceImpl(
          dio: dio,
        );
      });

      setUpAll(() {
        registerFallbackValue(RequestOptions(path: ''));
      });

      group(
        'Tests in getCharacters',
        () {
          const url = "${Urls.baseUrl}/character";
          const page = 1;
          const search = 'teste';
          test(
            'should return the list of characters the getCharacters function',
            () async {
              final responseData = requestCharactersJson;
              when(
                () => dio.get(
                  url,
                  queryParameters: {'page': page, 'name': search},
                ),
              ).thenAnswer(
                (_) async => Response(
                  data: responseData,
                  statusCode: 200,
                  requestOptions: RequestOptions(path: url),
                ),
              );
              final response = await datasource.getCharacters(
                page,
                search,
              );
              expect(response, isA<CharacterReturnModel>());
            },
          );

          test(
            'Should return empty CharacterReturnModel for 404 "Nothing here" error',
            () async {
              final Map<String, dynamic> responseData = {
                'error': 'There is nothing here'
              };
              when(
                () => dio.get(
                  url,
                  queryParameters: {
                    'page': page,
                    'name': search,
                  },
                ),
              ).thenThrow(
                DioException(
                  requestOptions: RequestOptions(
                    path: url,
                  ),
                  response: Response(
                    requestOptions: RequestOptions(
                      path: url,
                    ),
                    data: responseData,
                    statusCode: 404,
                  ),
                ),
              );

              final result = await datasource.getCharacters(
                page,
                search,
              );
              expect(result, isA<CharacterReturnModel>());
              expect(result.info.count, 0);
              expect(result.info.pages, 1);
              expect(result.info.next, null);
              expect(result.info.prev, null);
              expect(result.results.isEmpty, true);
            },
          );

          test(
            'It should throw an error with response in statusMessage',
            () async {
              when(
                () => dio.get(
                  url,
                  queryParameters: {
                    'page': page,
                    'name': search,
                  },
                ),
              ).thenThrow(
                DioException(
                  requestOptions: RequestOptions(
                    path: url,
                  ),
                  response: Response(
                    requestOptions: RequestOptions(
                      path: url,
                    ),
                    statusMessage: 'Mensagem no e.response?.statusMessage',
                    data: {},
                    statusCode: 404,
                  ),
                ),
              );

              expect(
                () async => await datasource.getCharacters(
                  page,
                  search,
                ),
                throwsA(isA<Exception>()),
              );
            },
          );

          test(
            'Should generate an unresponsive error',
            () async {
              when(
                () => dio.get(
                  url,
                  queryParameters: {
                    'page': page,
                    'name': search,
                  },
                ),
              ).thenThrow(
                DioException(
                  requestOptions: RequestOptions(
                    path: url,
                  ),
                  response: null,
                ),
              );
              expect(
                () async => await datasource.getCharacters(
                  page,
                  search,
                ),
                throwsA(isA<Exception>()),
              );
            },
          );

          test(
            'Should throw an unknown error',
            () async {
              when(
                () => dio.get(
                  url,
                  queryParameters: {'page': page, 'name': search},
                ),
              ).thenThrow(
                Exception(
                  'Unexpected error',
                ),
              );

              expect(
                () async => await datasource.getCharacters(
                  page,
                  search,
                ),
                throwsA(isA<Exception>()),
              );
            },
          );
        },
      );

      group(
        'Tests in getCharactersFromUrl',
        () {
          test(
            'Should return a list of CharacterModel',
            () async {
              when(() => dio.get(charactersUrlsMock[0])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: charactersUrlsMock[0],
                  ),
                  data: characterListMock[0].toJson(),
                  statusCode: 200,
                ),
              );
              when(() => dio.get(charactersUrlsMock[1])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: charactersUrlsMock[1],
                  ),
                  data: characterListMock[1].toJson(),
                  statusCode: 200,
                ),
              );
              final results = await datasource.getCharactersFromUrl(
                charactersUrlsMock.sublist(0, 2),
              );
              expect(
                results,
                equals(
                  characterListMock.sublist(0, 2),
                ),
              );

              verify(() => dio.get(charactersUrlsMock[0])).called(1);
              verify(() => dio.get(charactersUrlsMock[1])).called(1);
            },
          );

          test(
            'should throw an exception when DioException occurs',
            () async {
              when(() => dio.get(charactersUrlsMock[0])).thenAnswer(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: charactersUrlsMock[0],
                  ),
                  data: characterListMock[0].toJson(),
                  statusCode: 200,
                ),
              );
              when(() => dio.get(charactersUrlsMock[1])).thenThrow(
                DioException(
                  requestOptions: RequestOptions(
                    path: charactersUrlsMock[1],
                  ),
                  response: null,
                  message: 'Failed to load characteres',
                ),
              );
              when(() => dio.get(charactersUrlsMock[2])).thenThrow(
                (_) async => Response(
                  requestOptions: RequestOptions(
                    path: charactersUrlsMock[2],
                  ),
                  data: characterListMock[2].toJson(),
                  statusCode: 200,
                ),
              );
              expect(
                () async => await datasource.getCharactersFromUrl(
                  charactersUrlsMock.sublist(0, 3),
                ),
                throwsA(
                  isA<Exception>().having(
                    (e) => e.toString(),
                    'Error message',
                    contains(
                      'Failed to fetch characteres: Failed to load characteres',
                    ),
                  ),
                ),
              );
              verify(() => dio.get(charactersUrlsMock[0])).called(1);
              verify(() => dio.get(charactersUrlsMock[1])).called(1);
              verifyNever(() => dio.get(charactersUrlsMock[2]));
            },
          );

          test(
            'Should throw an unknown error',
            () async {
              when(
                () => dio.get(
                  charactersUrlsMock[0],
                ),
              ).thenThrow(
                Exception(
                  'Unexpected error',
                ),
              );

              expect(
                () async => await datasource.getCharactersFromUrl(
                  charactersUrlsMock.sublist(0, 3),
                ),
                throwsA(
                  isA<Exception>().having(
                    (e) => e.toString(),
                    'Error message',
                    contains(
                      'Failed to fetch characteres',
                    ),
                  ),
                ),
              );
              verify(() => dio.get(charactersUrlsMock[0])).called(1);
              verifyNever(() => dio.get(charactersUrlsMock[1]));
              verifyNever(() => dio.get(charactersUrlsMock[2]));
            },
          );
        },
      );

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

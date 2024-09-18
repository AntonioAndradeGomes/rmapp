import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/common/constants/urls.dart';
import 'package:rmapp/src/data/datasources/remote/character_datasource.dart';
import 'package:rmapp/src/data/models/character_return_model.dart';

import '../../../../mocks.dart';

class MockDio extends Mock implements Dio {}

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
        },
      );
    },
  );
}

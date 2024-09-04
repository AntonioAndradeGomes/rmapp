import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:rmapp/src/common/constants/urls.dart';
import 'package:rmapp/src/data/models/character_return_model.dart';

abstract interface class CharacterDatasource {
  Future<CharacterReturnModel> getCharacters(
    int page,
    String search,
  );
}

class CharacterDatasourceImpl implements CharacterDatasource {
  final Dio _dio;

  CharacterDatasourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<CharacterReturnModel> getCharacters(
    int page,
    String search,
  ) async {
    try {
      const url = "${Urls.baseUrl}/character";
      final response = await _dio.get(
        url,
        queryParameters: {
          'page': page,
          if (search.isNotEmpty) 'name': search,
        },
      );
      if (response.statusCode == 200) {
        return CharacterReturnModel.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load characters: ${response.statusMessage}');
      }
    } on DioException catch (e, s) {
      if (e.response != null) {
        log(
          'Dio error: ${e.response?.statusCode} ${e.response?.statusMessage}',
          error: e,
          stackTrace: s,
        );
        throw Exception(
          'Failed to load characters: ${e.response?.statusMessage}',
        );
      } else {
        log(
          'Error sending request: ${e.message}',
          stackTrace: s,
        );
        throw Exception(
          'Failed to send request: ${e.message}',
        );
      }
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
      throw Exception(
        'Failed to send request: ${e.toString()}',
      );
    }
  }
}

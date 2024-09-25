import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rmapp/src/common/constants/urls.dart';
import 'package:rmapp/src/common/models/info_model.dart';
import 'package:rmapp/src/data/character/models/character_model.dart';
import 'package:rmapp/src/data/character/models/character_return_model.dart';
import 'package:rmapp/src/data/episode/models/episode_model.dart';

abstract interface class CharacterDatasource {
  Future<CharacterReturnModel> getCharacters(
    int page,
    String search,
  );

  Future<List<EpisodeModel>> getEpisodeFromUrls(
    List<String> urls,
  );

  Future<List<CharacterModel>> getCharactersFromUrl(
    List<String> urls,
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
      final query = {
        'page': page,
        if (search.isNotEmpty) 'name': search,
      };
      final response = await _dio.get(
        url,
        queryParameters: query,
      );

      return CharacterReturnModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e, s) {
      if (e.response != null) {
        if (e.response!.data is Map<String, dynamic> &&
            e.response!.data['error'] == "There is nothing here") {
          log('Dio error: 404 -> Nothing here - Search returns empty');
          return const CharacterReturnModel(
            info: InfoModel(
              count: 0,
              pages: 1,
              next: null,
              prev: null,
            ),
            results: [],
          );
        }
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
          'Failed to perform request: ${e.message}',
          stackTrace: s,
          error: e,
        );
        throw Exception(
          'Failed to perform request: ${e.message}',
        );
      }
    } catch (e, s) {
      log(
        e.toString(),
        error: e,
        stackTrace: s,
      );
      throw Exception(
        'An unknown error occurred: ${e.toString()}',
      );
    }
  }

  @override
  Future<List<EpisodeModel>> getEpisodeFromUrls(
    List<String> urls,
  ) async {
    try {
      final responses = await Future.wait(
        urls.map(
          (url) => _dio.get(url),
        ),
      );
      final episodes = responses.map(
        (response) {
          return EpisodeModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        },
      ).toList();

      return episodes;
    } on DioException catch (e, s) {
      // Tratamento de erro específico para requisições com Dio
      log(
        'Dio error: ${e.message}',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to fetch episodes: ${e.message}');
    } catch (e, s) {
      // Tratamento de erro genérico
      log(
        'Error: $e',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to fetch episodes, an unknown error occurred');
    }
  }

  @override
  Future<List<CharacterModel>> getCharactersFromUrl(
    List<String> urls,
  ) async {
    try {
      final responses = await Future.wait(
        urls.map(
          (url) => _dio.get(url),
        ),
      );
      final characters = responses.map(
        (response) {
          return CharacterModel.fromJson(
            response.data as Map<String, dynamic>,
          );
        },
      ).toList();

      return characters;
    } on DioException catch (e, s) {
      log(
        'Dio error: ${e.message}',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to fetch characteres: ${e.message}');
    } catch (e, s) {
      // Tratamento de erro genérico
      log(
        'Error: $e',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to fetch characteres');
    }
  }
}

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:rmapp/src/data/episode/models/episode_model.dart';

abstract class EpisodeDatasource {
  Future<List<EpisodeModel>> getEpisodeFromUrls(
    List<String> urls,
  );
}

class EpisodeDatasourceImpl implements EpisodeDatasource {
  final Dio _dio;

  EpisodeDatasourceImpl({
    required Dio dio,
  }) : _dio = dio;

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
      throw Exception(
        'Failed to fetch episodes, an unknown error occurred',
      );
    }
  }
}

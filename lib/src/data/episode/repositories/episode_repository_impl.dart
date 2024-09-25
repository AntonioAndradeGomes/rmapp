import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/data/episode/datasources/remote/episode_datasource.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/domain/episode/repositories/episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  final EpisodeDatasource _datasource;

  EpisodeRepositoryImpl({
    required EpisodeDatasource datasource,
  }) : _datasource = datasource;

  @override
  Future<Result<List<EpisodeEntity>, CustomException>> getEpisodesFromUrls(
    List<String> urls,
  ) async {
    try {
      final episodes = await _datasource.getEpisodeFromUrls(urls);
      return episodes.toSuccess();
    } catch (e) {
      return CustomException(
        messageError: e.toString(),
        customMessage:
            'An unexpected error occurred while fetching the episodes. Please try again.',
      ).toFailure();
    }
  }
}

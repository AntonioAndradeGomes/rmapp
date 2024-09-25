import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';

abstract interface class EpisodeRepository {
  Future<Result<List<EpisodeEntity>, CustomException>> getEpisodesFromUrls(
    List<String> urls,
  );
}

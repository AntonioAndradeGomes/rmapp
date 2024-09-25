import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/domain/episode/repositories/episode_repository.dart';

class GetEpisodesFromUrlsUsecase
    implements Usecase<List<EpisodeEntity>, List<String>> {
  final EpisodeRepository _repository;

  GetEpisodesFromUrlsUsecase({
    required EpisodeRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<List<EpisodeEntity>, CustomException>> call(
    List<String> input,
  ) {
    return _repository.getEpisodesFromUrls(input);
  }
}

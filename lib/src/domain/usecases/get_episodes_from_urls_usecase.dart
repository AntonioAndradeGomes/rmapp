import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class GetEpisodesFromUrlsUsecase
    implements Usecase<List<EpisodeEntity>, List<String>> {
  final CharactersRepository _repository;

  GetEpisodesFromUrlsUsecase({
    required CharactersRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<List<EpisodeEntity>, CustomException>> call(
    List<String> input,
  ) {
    return _repository.getEpisodesFromUrls(input);
  }
}

import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import '../repositories/characters_repository.dart';

class GetCharacteresFromUrlsUsecase
    implements Usecase<List<CharacterEntity>, List<String>> {
  final CharactersRepository _repository;

  GetCharacteresFromUrlsUsecase({
    required CharactersRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<List<CharacterEntity>, CustomException>> call(
    List<String> input,
  ) {
    return _repository.getCharactersFromUrls(input);
  }
}

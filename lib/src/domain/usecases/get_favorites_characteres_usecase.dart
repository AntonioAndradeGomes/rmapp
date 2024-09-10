import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class GetFavoritesCharacteresUseCase
    implements Usecase<List<CharacterEntity>, NoParams> {
  final CharactersRepository _repository;

  GetFavoritesCharacteresUseCase({
    required CharactersRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<List<CharacterEntity>, CustomException>> call(NoParams input) {
    return _repository.getCharactersFavorites();
  }
}

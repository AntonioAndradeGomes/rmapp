import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class RemoveCharacterFavoriteUsecase implements Usecase<int, CharacterEntity> {
  final CharactersRepository _repository;

  RemoveCharacterFavoriteUsecase({
    required CharactersRepository repository,
  }) : _repository = repository;
  @override
  Future<Result<int, CustomException>> call(CharacterEntity input) {
    return _repository.removeCharacterInLocalStorage(input);
  }
}

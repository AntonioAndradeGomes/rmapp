import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/characters_search_input.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class GetApiCharacteresUsecase
    implements Usecase<CharacterReturnEntity, CharactersSearchInput> {
  final CharactersRepository _repository;

  GetApiCharacteresUsecase({
    required CharactersRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<CharacterReturnEntity, CustomException>> call(
    CharactersSearchInput input,
  ) {
    return _repository.getCaractersFromApi(
      input.page,
      input.search,
    );
  }
}

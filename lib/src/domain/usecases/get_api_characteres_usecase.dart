import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/usecase/usecase.dart';
import 'package:rmapp/src/domain/entities/caracter_search_input.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class GetApiCharacteresUsecase
    implements Usecase<CharacterReturnEntity, CaracterSearchInput> {
  final CharactersRepository _repository;

  GetApiCharacteresUsecase({
    required CharactersRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<CharacterReturnEntity, CustomException>> call(
      CaracterSearchInput input) {
    return _repository.getCaractersFromApi(
      input.page,
      input.search,
    );
  }
}

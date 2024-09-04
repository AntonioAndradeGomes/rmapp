import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';

abstract interface class CharactersRepository {
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    int page,
    String search,
  );
}

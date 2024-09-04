import 'package:result_dart/result_dart.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/data/datasource/character_datasource.dart';
import 'package:rmapp/src/domain/entities/character_return_entity.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class CharactersRepositoryImpl implements CharactersRepository {
  final CharacterDatasource _datasource;

  CharactersRepositoryImpl({
    required CharacterDatasource datasource,
  }) : _datasource = datasource;
  @override
  Future<Result<CharacterReturnEntity, CustomException>> getCaractersFromApi(
    int page,
    String search,
  ) async {
    try {
      final characterReturnModel =
          await _datasource.getCharacters(page, search);
      return Success(characterReturnModel);
    } on CustomException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        CustomException(
          messageError: e.toString(),
          customMessage:
              'Ocorreu um erro inesperado. Por favor, tente novamente.',
        ),
      );
    }
  }
}

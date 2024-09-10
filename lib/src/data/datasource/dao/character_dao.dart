import 'package:floor/floor.dart';
import 'package:rmapp/src/data/models/character_model.dart';

@dao
abstract class CharacterDao {
  //retorna o id adicionado
  @insert
  Future<int> insertCharacter(CharacterModel model);

  @delete
  Future<void> deleteCharacter(CharacterModel model);

  @Query('SELECT * FROM characters')
  Future<List<CharacterModel>> getAll();

  @Query('''
    SELECT * FROM characters 
    WHERE id = :id 
      AND name = :name 
      AND status = :status 
      AND species = :species 
      AND type = :type 
      AND gender = :gender 
      AND locationName = :locationName 
      AND episode = :episodes 
      AND image = :image
  ''')
  Future<CharacterModel?> findCharacterByFullDetails(
    int id,
    String name,
    String status,
    String species,
    String type,
    String gender,
    String locationName,
    String episodes,
    String image,
  );

  @Query('SELECT * FROM characters WHERE id = :id')
  Future<CharacterModel?> findCharacterById(int id);

  // Função para atualizar os dados de um CharacterModel
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateCharacter(CharacterModel model);
}

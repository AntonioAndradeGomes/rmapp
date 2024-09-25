import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:rmapp/src/data/character/datasources/dao/character_dao.dart';
import 'package:rmapp/src/data/character/models/character_model.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [CharacterModel])
abstract class AppDatabase extends FloorDatabase {
  CharacterDao get characterDao;
}

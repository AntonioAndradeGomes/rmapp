// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CharacterDao? _characterDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `characters` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `status` TEXT NOT NULL, `species` TEXT NOT NULL, `type` TEXT NOT NULL, `gender` TEXT NOT NULL, `locationName` TEXT NOT NULL, `episodes` TEXT NOT NULL, `image` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CharacterDao get characterDao {
    return _characterDaoInstance ??= _$CharacterDao(database, changeListener);
  }
}

class _$CharacterDao extends CharacterDao {
  _$CharacterDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _characterModelInsertionAdapter = InsertionAdapter(
            database,
            'characters',
            (CharacterModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'status': item.status,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender,
                  'locationName': item.locationName,
                  'episodes': item.episodes,
                  'image': item.image
                }),
        _characterModelUpdateAdapter = UpdateAdapter(
            database,
            'characters',
            ['id'],
            (CharacterModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'status': item.status,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender,
                  'locationName': item.locationName,
                  'episodes': item.episodes,
                  'image': item.image
                }),
        _characterModelDeletionAdapter = DeletionAdapter(
            database,
            'characters',
            ['id'],
            (CharacterModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'status': item.status,
                  'species': item.species,
                  'type': item.type,
                  'gender': item.gender,
                  'locationName': item.locationName,
                  'episodes': item.episodes,
                  'image': item.image
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CharacterModel> _characterModelInsertionAdapter;

  final UpdateAdapter<CharacterModel> _characterModelUpdateAdapter;

  final DeletionAdapter<CharacterModel> _characterModelDeletionAdapter;

  @override
  Future<List<CharacterModel>> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM characters',
        mapper: (Map<String, Object?> row) => CharacterModel(
            id: row['id'] as int,
            name: row['name'] as String,
            status: row['status'] as String,
            species: row['species'] as String,
            type: row['type'] as String,
            gender: row['gender'] as String,
            locationName: row['locationName'] as String,
            episodes: row['episodes'] as String,
            image: row['image'] as String));
  }

  @override
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
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM characters      WHERE id = ?1        AND name = ?2        AND status = ?3        AND species = ?4        AND type = ?5        AND gender = ?6        AND locationName = ?7        AND episodes = ?8        AND image = ?9',
        mapper: (Map<String, Object?> row) => CharacterModel(id: row['id'] as int, name: row['name'] as String, status: row['status'] as String, species: row['species'] as String, type: row['type'] as String, gender: row['gender'] as String, locationName: row['locationName'] as String, episodes: row['episodes'] as String, image: row['image'] as String),
        arguments: [
          id,
          name,
          status,
          species,
          type,
          gender,
          locationName,
          episodes,
          image
        ]);
  }

  @override
  Future<CharacterModel?> findCharacterById(int id) async {
    return _queryAdapter.query('SELECT * FROM characters WHERE id = ?1',
        mapper: (Map<String, Object?> row) => CharacterModel(
            id: row['id'] as int,
            name: row['name'] as String,
            status: row['status'] as String,
            species: row['species'] as String,
            type: row['type'] as String,
            gender: row['gender'] as String,
            locationName: row['locationName'] as String,
            episodes: row['episodes'] as String,
            image: row['image'] as String),
        arguments: [id]);
  }

  @override
  Future<int> insertCharacter(CharacterModel model) {
    return _characterModelInsertionAdapter.insertAndReturnId(
        model, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCharacter(CharacterModel model) async {
    await _characterModelUpdateAdapter.update(
        model, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteCharacter(CharacterModel model) async {
    await _characterModelDeletionAdapter.delete(model);
  }
}

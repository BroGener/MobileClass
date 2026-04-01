// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ItemDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ItemDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ItemDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ItemDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ItemDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorItemDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ItemDatabaseBuilderContract databaseBuilder(String name) =>
      _$ItemDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ItemDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ItemDatabaseBuilder(null);
}

class _$ItemDatabaseBuilder implements $ItemDatabaseBuilderContract {
  _$ItemDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ItemDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ItemDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ItemDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ItemDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ItemDatabase extends ItemDatabase {
  _$ItemDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ItemDAO? _myDAOInstance;

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
            'CREATE TABLE IF NOT EXISTS `Item` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `quantity` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ItemDAO get myDAO {
    return _myDAOInstance ??= _$ItemDAO(database, changeListener);
  }
}

class _$ItemDAO extends ItemDAO {
  _$ItemDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _itemInsertionAdapter = InsertionAdapter(
            database,
            'Item',
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _itemUpdateAdapter = UpdateAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                }),
        _itemDeletionAdapter = DeletionAdapter(
            database,
            'Item',
            ['id'],
            (Item item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'quantity': item.quantity
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Item> _itemInsertionAdapter;

  final UpdateAdapter<Item> _itemUpdateAdapter;

  final DeletionAdapter<Item> _itemDeletionAdapter;

  @override
  Future<List<Item>> getAllItems() async {
    return _queryAdapter.queryList('SELECT * FROM Item',
        mapper: (Map<String, Object?> row) => Item(
            row['id'] as int, row['quantity'] as int, row['name'] as String));
  }

  @override
  Future<int> insertItem(Item i) {
    return _itemInsertionAdapter.insertAndReturnId(i, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateItem(Item i) async {
    await _itemUpdateAdapter.update(i, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteItem(Item i) async {
    await _itemDeletionAdapter.delete(i);
  }
}

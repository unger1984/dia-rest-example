import 'dart:io';

import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:postgresql2/postgresql.dart';

import 'config_provider.dart';

class DatabaseProviderException implements Exception {
  final String message;
  DatabaseProviderException(this.message);
}

class DatabaseProvider {
  // Singleton pattern
  static final DatabaseProvider _dbManager = DatabaseProvider._internal();
  DatabaseProvider._internal();
  static DatabaseProvider get instance => _dbManager;

  // Members
  static Connection? _conn;
  final _initDBMemoizer = AsyncMemoizer<Connection>();

  Future<Connection> get conn async {
    _conn ??= await _initDBMemoizer.runOnce(() async {
      return await _initDB();
    });

    return _conn!;
  }

  Future<Connection> _initDB() async {
    final config = ConfigProvider.instance;
    final userpart = config.dbuser != null
        ? '${config.dbuser}${config.dbpass != null ? ':${config.dbpass}' : ''}@'
        : '';
    return await connect(
        'postgres://$userpart${config.dbhost}:${config.dbport}/${config.dbname}');
  }

  /// Update database from files
  static Future<void> migrationUp(Connection connection,
      {String path = 'migrations'}) async {
    await connection.execute(
        'CREATE TABLE IF NOT EXISTS "MigrationMeta" ("name" VARCHAR(255) UNIQUE PRIMARY KEY)');
    final entries = Directory(path)
        .listSync(recursive: false)
        .map((e) => basename(e.path))
        .toList();
    entries.sort();
    final existNames =
        await connection.query('select * from "MigrationMeta"').toList();
    for (var index = 0; index < entries.length; index++) {
      if (existNames
          .where((element) => element.toMap()['name'] == entries[index])
          .isEmpty) {
        final sql = File('$path/${entries[index]}').readAsStringSync();
        await connection.execute(sql);
        await connection.execute(
            'insert into "MigrationMeta" ("name") values (@name)',
            {'name': entries[index]});
        print('Migrated ${entries[index]}');
      }
    }
  }
}

import 'dart:io';

import 'package:dotenv/dotenv.dart' as dotenv;

final _DEFAULT_HOST = 'localhost';
final _DEFAULT_PORT = 8084;
final _DEFAULT_DBHOST = 'localhost';
final _DEFAULT_DBPORT = 5432;

class ConfigProvider {
  late String host;
  late int port;
  String? dbname;
  String? dbuser;
  String? dbpass;
  late String dbhost;
  late int dbport;
  late Directory uploadpath;
  late bool dbdebug;

  static final ConfigProvider _config = ConfigProvider._internal();

  ConfigProvider._internal() {
    dotenv.load();
    host =
        dotenv.isEveryDefined(['host']) ? dotenv.env['host']! : _DEFAULT_HOST;
    port = dotenv.isEveryDefined(['dbport'])
        ? int.tryParse(dotenv.env['port']!) ?? _DEFAULT_PORT
        : _DEFAULT_PORT;
    dbname = dotenv.env['dbname'];
    dbuser = dotenv.env['dbuser'];
    dbpass = dotenv.env['dbpass'];
    dbhost = dotenv.isEveryDefined(['dbhost'])
        ? dotenv.env['dbhost']!
        : _DEFAULT_DBHOST;
    dbport = dotenv.isEveryDefined(['dbport'])
        ? int.tryParse(dotenv.env['dbport']!) ?? _DEFAULT_DBPORT
        : _DEFAULT_DBPORT;
    dbdebug = dotenv.isEveryDefined(['dbdebug']) &&
        dotenv.env['dbport']?.toLowerCase() == 'true';
  }

  static ConfigProvider get instance => _config;

  Map<String, dynamic> toJson() {
    return {
      'dbname': dbname,
      'dbuser': dbuser,
      'dbpass': dbpass,
      'dbhost': dbhost,
      'dbport': dbport,
      'dbdebug': dbdebug,
    };
  }
}

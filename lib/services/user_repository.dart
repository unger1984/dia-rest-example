import 'package:dia_rest_example/models/user.dart';
import 'package:dia_rest_example/services/database_provider.dart';

class UserRepositiry {
  static final _dbProvider = DatabaseProvider.instance;

  static Future<User?> login(String login, String password) async {
    final conn = await _dbProvider.conn;
    var list = await conn.query(
        'select "id","login","name" from "User" where "login"=@login and "password"=@password',
        {'login': login, 'password': password}).toList();
    if (list.isNotEmpty) {
      return User.fromJson(list.first
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value)));
    }
    return null;
  }

  static Future<User?> byId(int id) async {
    final conn = await _dbProvider.conn;
    var list = await conn.query(
        'select "id","login","name" from "User" where "id"=@id',
        {'id': id}).toList();
    if (list.isNotEmpty) {
      return User.fromJson(list.first
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value)));
    }
    return null;
  }
}

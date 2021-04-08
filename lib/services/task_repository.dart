import 'package:dia_rest_example/models/task.dart';
import 'package:dia_rest_example/services/database_provider.dart';

class TaskRepositiry {
  static final _dbProvider = DatabaseProvider.instance;

  static Future<List<Task>> my(int userId) async {
    final conn = await _dbProvider.conn;
    var list = await conn.query(
        'select * from "Task" where "userId"=@userId order by "id"',
        {'userId': userId}).toList();

    return list
        .map((row) => Task.fromJson(
            row.toMap().map((key, value) => MapEntry(key.toString(), value))))
        .toList();
  }

  static Future<Task?> byId(int id) async {
    final conn = await _dbProvider.conn;
    var list = await conn
        .query('select * from "Task" where "id"=@id', {'id': id}).toList();
    if (list.isNotEmpty) {
      return Task.fromJson(list.first
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value)));
    }
    return null;
  }

  static Future<int> create(Task task) async {
    final conn = await _dbProvider.conn;
    return await conn.execute(
        'insert into "Task" ("userId","title","text") values (@userId,@title,@text)',
        task.toJson());
  }

  static Future<int> update(Task task) async {
    final conn = await _dbProvider.conn;
    return await conn.execute(
        'update "Task" set title=@title, text=@text where id=@id',
        task.toJson());
  }

  static Future<int> delete(int id) async {
    final conn = await _dbProvider.conn;
    return await conn.execute('delete from "Task" where id=@id', {'id': id});
  }
}

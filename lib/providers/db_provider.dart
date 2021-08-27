import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:todoey/models/task.dart';

final dbProvider = Provider((_) => DatabaseClient());

class DatabaseClient {
  static const _tableName = 'todos';
  late Database db;
  bool isInit = false;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    db = await openDatabase(
      path.join(dbPath, _tableName),
      onCreate: (db, verison) async {
        String query = '''
          CREATE TABLE IF NOT EXISTS $_tableName(
            id INTEGER PRIMARY KEY,
            task TEXT,
            isDone INTEGER
          )
        '''
            .trim()
            .replaceAll(RegExp(r'[\s]{2,}'), ' ');
        await db.execute(query);
      },
      version: 1,
    );
    isInit = true;
  }

  Future<void> insertTask(Task task) async {
    await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteTask(int id) async {
    await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (int i) {
      return Task(
        id: maps[i]['id'],
        task: maps[i]['task'],
        intDone: maps[i]['isDone'],
      );
    });
  }

  Future<void> updateTask(Task task) async {
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}

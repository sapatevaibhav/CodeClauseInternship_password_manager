import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:password_manager/Model/password_model.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'password_database.db';
  static const String tableName = 'passwords';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final path = join(await getDatabasesPath(), dbName);

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
          CREATE TABLE $tableName(
            userName TEXT PRIMARY KEY,
            description TEXT,
            password TEXT
          )
          ''',
        );
      },
    );
  }

  Future<void> insertPassword(passwords password) async {
    final db = await database;
    await db.insert(tableName, password.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<passwords>> getPasswords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return passwords(
        userName: maps[i]['userName'],
        description: maps[i]['description'],
        password: maps[i]['password'],
      );
    });
  }

 Future<void> deletePassword(String userName) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'userName = ?',
      whereArgs: [userName],
    );
  }
}

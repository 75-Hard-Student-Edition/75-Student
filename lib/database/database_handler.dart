import "dart:io";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_75/database/task_model_database_extension.dart';
import 'package:student_75/models/task_model.dart';

class DatabaseService {
  // Database is created at runtime so needs to be nullable (i think?)
  Database? _database;
  String? path;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    // Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    path = join(await getDatabasesPath(), 'test.db');
    // read sql from file, store as string
    String createDatabaseSql = await File("create_tables.sql").readAsString();

    _database = await openDatabase(
        // Set the path to the database.
        path!, onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      // get database from a file
      return db.execute(createDatabaseSql);
    }, version: 1);
  }

  void addTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.insert("task", task.toMap(userId),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // in terms of functionality this is the exact same as insertion
  void updateTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.insert("task", task.toMap(userId),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void deleteTaskRecord(int taskId) async {
    final db = await database;
    db.delete("task", where: 'task_id = ?', whereArgs: [taskId]);
  }
}

import "dart:io";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_75/database/database_service_interface.dart';
import 'package:student_75/database/task_model_database_extension.dart';
import 'package:student_75/database/account_model_database_extension.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';

class DatabaseService implements IDatabaseService {
  // AI generated code turns DatabaseService into a singleton pattern
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

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
    path = join(await getDatabasesPath(), '75_student_db.db');
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

  @override
  Future<void> addTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.insert("task", task.toMap(userId), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // in terms of functionality this is the exact same as insertion
  @override
  Future<void> updateTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.insert("task", task.toMap(userId), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeTaskRecord(int taskId) async {
    final db = await database;
    db.delete("task", where: 'task_id = ?', whereArgs: [taskId]);
  }

  @override
  Future<TaskModel?> queryTask(int taskId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query("task", where: "task_id = ?", whereArgs: [taskId]);
    if (maps.isNotEmpty) {
      return TaskModelDB.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<TaskModel>> fetchTodaysScheduledTasks(int userId) async {
    final db = await database;
    // Because the dates are stored as strings the selection for the current day
    // can't be done in sql
    List<Map<String, dynamic>> maps = await db.query("task");

    List<TaskModel> todaysTasks = [];
    for (var map in maps) {
      if (map["user_id"] == userId &&
          DateTime.parse(map["start_time"]).day == DateTime.now().day &&
          DateTime.parse(map["start_time"]).month == DateTime.now().month &&
          DateTime.parse(map["start_time"]).year == DateTime.now().year) {
        todaysTasks.add(TaskModelDB.fromMap(map));
      }
    }
    return todaysTasks;
  }

  @override
  Future<void> addAccountRecord(UserAccountModel account) async {
    final db = await database;
    await db.insert("user", account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateAccountRecord(UserAccountModel account) async {
    final db = await database;
    await db.insert("user", account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> removeAccountRecord(int userId) async {
    final db = await database;
    db.delete("user", where: 'user_id = ?', whereArgs: [userId]);
  }

  @override
  Future<UserAccountModel?> queryAccount(String username, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query("user", where: "username = ?", whereArgs: [username]);
    if (maps.isNotEmpty && maps.first["password"] == password) {
      return UserAccountModelDB.fromMap(maps.first);
    }
    return null;
  }
}

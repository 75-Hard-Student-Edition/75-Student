import "dart:io";
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_75/database/database_service_interface.dart';
import 'package:student_75/database/task_model_database_extension.dart';
import 'package:student_75/database/account_model_database_extension.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:flutter/services.dart' show rootBundle;

/// DatabaseService is a singleton class that manages the database connection and operations.
/// It provides methods to add, update, remove, and query task and user records.
/// It also initializes the database and creates the necessary tables if they do not exist.
/// The database is created at runtime and the path is stored in a nullable variable.
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

  /// Initializes the database by creating the necessary tables if they do not exist.
  /// It loads the SQL statements from the [assets] folder and executes them to create the tables.
  Future<void> initDatabase() async {
    path = join(await getDatabasesPath(), '75_student_db.db');

    String createDatabaseSql = await rootBundle.loadString('assets/create_tables.sql');

    _database = await openDatabase(
      path!,
      version: 1,
      onCreate: (db, version) async {
        print("🔧 Running SQL to create tables (onCreate)");
        await db.execute(createDatabaseSql);
      },
    );

    // Failsafe: Check if 'task' and 'user' tables exist
    final existingTables = await _database!.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name IN ('task', 'user');",
    );

    final existingTableNames = existingTables.map((e) => e['name']).toSet();

    if (!existingTableNames.contains('task') || !existingTableNames.contains('user')) {
      print("⚠️ One or more required tables are missing — creating them manually.");
      final statements = createDatabaseSql.split(';');
      for (final statement in statements) {
        final trimmed = statement.trim();
        if (trimmed.isNotEmpty) {
          try {
            await _database!.execute(trimmed + ';');
          } catch (e) {
            print("⚠️ SQL error in fallback: $e");
            print("🧨 Failed statement: $trimmed");
          }
        }
      }
    } else {
      print("✅ 'task' and 'user' tables exist.");
    }
  }

  /// Adds a task record to the database.
  /// If a task with the same ID already exists, it will be replaced.
  @override
  Future<void> addTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.insert("task", task.toMap(userId), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Updates a task record in the database.
  @override
  Future<void> updateTaskRecord(TaskModel task, int userId) async {
    final db = await database;
    await db.update("task", task.toMap(userId), where: "task_id = ?", whereArgs: [task.id]);
  }

  /// Removes a task record from the database.
  @override
  Future<void> removeTaskRecord(int taskId) async {
    final db = await database;
    db.delete("task", where: 'task_id = ?', whereArgs: [taskId]);
  }

  /// Queries a task record from the database by its ID.
  /// Returns the task record if found, otherwise returns null.
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

  /// Fetches all tasks scheduled for today for a specific user.
  /// The tasks are filtered by the user ID and the current date.
  /// Returns a list of tasks scheduled for today.
  /// Returns an empty list if no tasks are found.
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

  /// Adds a user account record to the database.
  /// If a user account with the same username already exists, it will be replaced.
  /// The password is stored separately for security reasons.
  @override
  Future<void> addAccountRecord(UserAccountModel account, String password) async {
    final db = await database;
    await db.insert("user", account.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    // Add password
    await db.update("user", {"password": password},
        where: "username = ?", whereArgs: [account.username]);
  }

  /// Updates a user account record in the database.
  @override
  Future<void> updateAccountRecord(UserAccountModel account) async {
    final db = await database;
    await db.update("user", account.toMap(), where: "id = ?", whereArgs: [account.id]);
  }

  /// Removes a user account record from the database.
  /// This method is used when a user account is deleted.
  @override
  Future<void> removeAccountRecord(int userId) async {
    final db = await database;
    db.delete("user", where: 'user_id = ?', whereArgs: [userId]);
  }

  /// Queries a user account record from the database by its username and password.
  /// Returns the user account record if found and the password matches, otherwise returns null.
  /// This method is used for user login.
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

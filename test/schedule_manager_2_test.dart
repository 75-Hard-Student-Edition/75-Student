import 'package:flutter_test/flutter_test.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/database/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('ScheduleManager Tests', () {
    late DatabaseService databaseService;
    late AccountManager accountManager;
    late ScheduleManager scheduleManager;

    setUp(() async {
      databaseService = DatabaseService();
      await databaseService.initDatabase();

      accountManager = AccountManager();
      await accountManager.createAccount(
          UserAccountModel(
            id: 999,
            username: 'testuser',
            streak: 5,
            difficulty: Difficulty.medium,
            categoryOrder: [
              TaskCategory.academic,
              TaskCategory.social,
              TaskCategory.health,
              TaskCategory.hobby,
              TaskCategory.chore,
              TaskCategory.hobby,
              TaskCategory.employment
            ],
            sleepDuration: Duration(hours: 8),
            bedtime: DateTime.now(),
            bedtimeNotifyBefore: Duration(minutes: 30),
            mindfulnessDuration: Duration(minutes: 10),
          ),
          "password123");
      await accountManager.login('testuser', 'password123');

      scheduleManager = await ScheduleManager.create(
        displayErrorCallback: (message) => print(message),
        accountManager: accountManager,
        userBinarySelectCallback: (task1, task2, message) async {
          return task1; // Simulate user selecting the first task
        },
      );
    });

    tearDown(() async {
      for (var task in scheduleManager.schedule.tasks) {
        scheduleManager
            .deleteTask(task.id); //! Schedule manager tests are broken because we don't await this
      }
      await accountManager.deleteAccount(999);
      await databaseService.database.then((db) => db.close());
    });

    test("Schedule is initially empty", () {
      expect(scheduleManager.schedule.tasks.isEmpty, true);
    });

    test("Add task to schedule", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );

      // Act
      scheduleManager.addTask(task);

      // Assert
      expect(scheduleManager.schedule.tasks.length, 1);
      expect(scheduleManager.schedule.tasks[0].name, "Test Task");
    });

    test("Remove task from schedule", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );
      scheduleManager.addTask(task);

      // Act
      scheduleManager.deleteTask(task.id);

      // Assert
      expect(scheduleManager.schedule.tasks.isEmpty, true);
    });

    test("Edit task in schedule", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );
      scheduleManager.addTask(task);

      // Act
      final editedTask = task.copyWith(name: "Edited Task");
      scheduleManager.editTask(editedTask);

      // Assert
      expect(scheduleManager.schedule.tasks[0].name, "Edited Task");
    });

    test("Postpone task", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );
      scheduleManager.addTask(task);

      // Act
      scheduleManager.postPoneTask(task.id);

      // Assert
      expect(scheduleManager.schedule.tasks.isEmpty, true);
    });

    test("Complete task", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );
      scheduleManager.addTask(task);

      // Act
      scheduleManager.completeTask(task.id);

      // Assert
      expect(scheduleManager.schedule.tasks[0].isComplete, true);
    });

    test("Uncomplete task", () {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Test Task",
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        isMovable: true,
      );
      scheduleManager.addTask(task);
      scheduleManager.completeTask(task.id);

      // Act
      scheduleManager.uncompleteTask(task.id);

      // Assert
      expect(scheduleManager.schedule.tasks[0].isComplete, false);
    });
  });
}

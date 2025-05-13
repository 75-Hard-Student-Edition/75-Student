import 'package:flutter_test/flutter_test.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/database/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/account_manager/account_manager_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseService Tests', () {
    late DatabaseService databaseService;

    setUp(() async {
      databaseService = DatabaseService();
      await databaseService.initDatabase();
    });

    tearDown(() async {
      await databaseService.database.then((db) => db.close());
    });

    test('Add and query user account', () async {
      // Arrange
      final userAccount = UserAccountModel(
        id: 1,
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
      );

      // Act
      await DatabaseService().addAccountRecord(userAccount, 'password123');
      final queriedAccount = await DatabaseService().queryAccount('testuser', 'password123');

      // Assert
      expect(queriedAccount, isNotNull);
      expect(queriedAccount?.id, userAccount.id);
      expect(queriedAccount?.username, userAccount.username);
      expect(queriedAccount?.streak, userAccount.streak);
      expect(queriedAccount?.categoryOrder, userAccount.categoryOrder);
      expect(queriedAccount?.sleepDuration, userAccount.sleepDuration);
      expect(queriedAccount?.bedtime, userAccount.bedtime);
      expect(queriedAccount?.bedtimeNotifyBefore, userAccount.bedtimeNotifyBefore);
      expect(queriedAccount?.mindfulnessDuration, userAccount.mindfulnessDuration);
    });

    test('Update user account', () async {
      // Arrange
      final userAccount = UserAccountModel(
        id: 2,
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
      );

      await DatabaseService().addAccountRecord(userAccount, 'password123');

      // Act
      final int newStreak = 10;
      await DatabaseService().updateAccountRecord(userAccount.copyWith(streak: newStreak));
      final updatedAccount = await DatabaseService().queryAccount('testuser', 'password123');

      // Assert
      expect(updatedAccount, isNotNull);
      expect(updatedAccount?.streak, newStreak);
    });

    test('Remove user account', () async {
      // Arrange
      final userAccount = UserAccountModel(
        id: 3,
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
      );

      await DatabaseService().addAccountRecord(userAccount, 'password123');

      // Act
      await DatabaseService().removeAccountRecord(userAccount.id);
      final removedAccount = await DatabaseService().queryAccount('testuser', 'password123');

      // Assert
      expect(removedAccount, isNull);
    });

    test('Add and query task', () async {
      // Arrange
      final task = TaskModel(
        id: 1,
        name: "Task 1",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now().add(Duration(hours: 1)),
        duration: Duration(hours: 1),
        period: Duration(days: 1),
        notifyBefore: Duration(minutes: 10),
      );
      final int userId = 1;

      // Act
      await DatabaseService().addTaskRecord(task, userId);
      final queriedTask = await DatabaseService().queryTask(task.id);

      // Assert
      expect(queriedTask, isNotNull);
      expect(queriedTask?.id, task.id);
      expect(queriedTask?.name, task.name);
      expect(queriedTask?.isMovable, task.isMovable);
      expect(queriedTask?.category, task.category);
      expect(queriedTask?.priority, task.priority);
      expect(queriedTask?.startTime, task.startTime);
      expect(queriedTask?.duration, task.duration);
      expect(queriedTask?.period, task.period);
      // expect(queriedTask?.notifyBefore, task.notifyBefore);
    });
  });

  test("Update task", () async {
    // Arrange
    final task = TaskModel(
      id: 2,
      name: "Task 2",
      isMovable: true,
      category: TaskCategory.academic,
      priority: TaskPriority.medium,
      startTime: DateTime.now().add(Duration(hours: 1)),
      duration: Duration(hours: 1),
      period: Duration(days: 1),
      notifyBefore: Duration(minutes: 10),
    );
    final int userId = 1;

    await DatabaseService().addTaskRecord(task, userId);

    // Act
    final updatedTask = task.copyWith(name: "Updated Task");
    await DatabaseService().updateTaskRecord(updatedTask, userId);
    final queriedTask = await DatabaseService().queryTask(updatedTask.id);

    // Assert
    expect(queriedTask, isNotNull);
    expect(queriedTask?.name, updatedTask.name);
  });

  test("Remove task", () async {
    // Arrange
    final task = TaskModel(
      id: 3,
      name: "Task 3",
      isMovable: true,
      category: TaskCategory.academic,
      priority: TaskPriority.medium,
      startTime: DateTime.now().add(Duration(hours: 1)),
      duration: Duration(hours: 1),
      period: Duration(days: 1),
      notifyBefore: Duration(minutes: 10),
    );
    final int userId = 1;

    await DatabaseService().addTaskRecord(task, userId);

    // Act
    await DatabaseService().removeTaskRecord(task.id);
    final removedTask = await DatabaseService().queryTask(task.id);

    // Assert
    expect(removedTask, isNull);
  });

  test("Fetch today's scheduled tasks", () async {
    // Arrange
    final task1 = TaskModel(
      id: 4,
      name: "Task 4",
      isMovable: true,
      category: TaskCategory.academic,
      priority: TaskPriority.medium,
      startTime: DateTime.now(),
      duration: Duration(hours: 1),
      period: Duration(days: 1),
      notifyBefore: Duration(minutes: 10),
    );
    final task2 = TaskModel(
      id: 5,
      name: "Task 5",
      isMovable: true,
      category: TaskCategory.academic,
      priority: TaskPriority.medium,
      startTime: DateTime.now(),
      duration: Duration(hours: 1),
      period: Duration(days: 1),
      notifyBefore: Duration(minutes: 10),
    );
    final int userId = 1;

    await DatabaseService().addTaskRecord(task1, userId);
    await DatabaseService().addTaskRecord(task2, userId);

    // Act
    final tasks = await DatabaseService().fetchTodaysScheduledTasks(userId);

    // Assert
    expect(tasks.length, greaterThanOrEqualTo(2));
    expect(tasks.any((task) => task.id == task1.id), isTrue);
    expect(tasks.any((task) => task.id == task2.id), isTrue);
  });
}

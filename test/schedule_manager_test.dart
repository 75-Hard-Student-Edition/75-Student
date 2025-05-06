import 'package:flutter_test/flutter_test.dart'; // for Flutter test bindings
import 'package:test/test.dart'
    as coreTest; // aliasing 'test' from package:test

// Import your project's files for classes used in the test
import 'package:student_75/Components/schedule_manager/schedule_manager.dart'; // For ScheduleManager class
import 'package:student_75/Components/schedule_manager/schedule_generator.dart'; // For ScheduleGenerator class
import 'package:student_75/models/task_model.dart'; // For TaskModel class
import 'package:student_75/models/difficulty_enum.dart'; // For Difficulty enum
import 'package:student_75/models/user_account_model.dart'; // For UserAccountModel class
import 'package:student_75/Components/account_manager/account_manager.dart'; // For AccountManager class

// Import sqflite_common_ffi for the database
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // To handle database in test environment

// Define MockAccountManager to simulate the behavior of AccountManager for testing
class MockAccountManager extends AccountManager {
  @override
  UserAccountModel get userAccount => UserAccountModel(
        id: 1,
        username: "testuser",
        streak: 0,
        difficulty: Difficulty.medium,
        categoryOrder: [TaskCategory.academic],
        sleepDuration: Duration(hours: 8),
        bedtime: DateTime.now(),
        bedtimeNotifyBefore: Duration(minutes: 30),
        mindfulnessDuration: Duration(minutes: 15),
      );

  // Override methods if needed for your test
  @override
  int getUserId() {
    return 1; // Mock user ID
  }

  @override
  String getUsername() {
    return "testuser"; // Mock username
  }

  @override
  Difficulty getDifficulty() {
    return Difficulty.medium; // Mock difficulty level
  }

  @override
  List<TaskCategory> getCategoryOrder() {
    return [TaskCategory.academic]; // Mock category order
  }
}

void main() {
  // Ensure that the Flutter bindings are initialized before running the tests
  TestWidgetsFlutterBinding.ensureInitialized();

  late ScheduleManager scheduleManager;
  late TaskModel task1;
  late TaskModel task2;

  setUp(() async {
    // Initialize sqflite for testing (using ffi for testing environment)
    databaseFactory = databaseFactoryFfi;

    // Create ScheduleManager using the named constructor
    scheduleManager = await ScheduleManager.create(
      displayErrorCallback: (message) => print("Error: $message"),
      accountManager: MockAccountManager(),
      userBinarySelectCallback: (task1, task2, message) async => task1,
    );

    // Mock tasks
    task1 = TaskModel(
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

    task2 = TaskModel(
      id: 2,
      name: "Task 2",
      isMovable: true,
      category: TaskCategory.social,
      priority: TaskPriority.low,
      startTime: DateTime.now().add(Duration(hours: 3)),
      duration: Duration(hours: 1),
      period: Duration(days: 1),
      notifyBefore: Duration(minutes: 10),
    );
  });

  group('ScheduleManager Tests', () {
    coreTest.test('Check if schedule is empty initially', () {
      expect(scheduleManager.schedule.isEmpty, true);
    });

    coreTest.test('Check schedule length', () {
      scheduleManager.addTask(task1);
      expect(scheduleManager.schedule.length, 1);
    });

    coreTest.test('Check last task', () {
      scheduleManager.addTask(task1);
      expect(scheduleManager.schedule.last, task1);
    });

    coreTest.test('Sort tasks in schedule', () {
      scheduleManager.addTask(task2);
      scheduleManager.addTask(task1);
      scheduleManager.schedule.sort();
      expect(scheduleManager.schedule.tasks[0], task1);
    });

    coreTest.test('Add task to schedule', () {
      scheduleManager.addTask(task1);
      expect(scheduleManager.schedule.tasks.contains(task1), true);
    });

    coreTest.test('Remove task from schedule', () {
      scheduleManager.addTask(task1);
      scheduleManager.deleteTask(task1.id);
      expect(scheduleManager.schedule.tasks.contains(task1), false);
    });

    coreTest.test('Edit task in schedule', () {
      scheduleManager.addTask(task1);
      TaskModel editedTask = task1.copyWith(name: "Edited Task");
      scheduleManager.editTask(editedTask);
      expect(scheduleManager.schedule.tasks[0].name, "Edited Task");
    });

    coreTest.test('Get task from ID', () {
      scheduleManager.addTask(task1);
      TaskModel task = scheduleManager.schedule.getTaskModelFromId(task1.id)!;
      expect(task.id, task1.id);
    });

    coreTest.test('Get task index from ID', () {
      scheduleManager.addTask(task1);
      int index = scheduleManager.schedule.getTaskIndexFromId(task1.id);
      expect(index, 0);
    });

    coreTest.test('Check move possible for task', () {
      scheduleManager.addTask(task1);
      scheduleManager.addTask(task2);
      DateTime? possibleMoveTime = ScheduleGenerator.checkMovePossible(
        scheduleManager.schedule,
        task1,
        scheduleManager.accManager,
      );
      expect(possibleMoveTime, isNotNull);
    });
  });
}

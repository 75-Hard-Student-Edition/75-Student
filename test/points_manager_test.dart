import 'package:student_75/Components/points_manager.dart'; // Correct path to PointsManager
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart'; // Import the Schedule class

class MockAccountManager extends Mock implements AccountManager {}

void main() {
  group('PointsManager Tests', () {
    late PointsManager pointsManager;
    late MockAccountManager mockAccountManager;

    // Set up mock AccountManager before each test
    setUp(() {
      mockAccountManager = MockAccountManager();
      // Mocking getDifficulty and getCategoryOrder methods
      when(() => mockAccountManager.getDifficulty())
          .thenReturn(Difficulty.medium);
      when(() => mockAccountManager.getCategoryOrder()).thenReturn([
        TaskCategory.academic,
        TaskCategory.social,
        TaskCategory.hobby,
      ]);

      // Create a PointsManager instance with the mocked AccountManager
      pointsManager = PointsManager(
        initialSchedule: Schedule(tasks: []),
        accountManager: mockAccountManager,
      );
    });

    test('addTask should update maxPoints and pointsToPass', () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);

      expect(pointsManager.maxPoints, greaterThan(0));
      expect(pointsManager.pointsToPass, greaterThan(0));
    });

    test('getTaskPoints should calculate task points based on category order',
        () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      int points = pointsManager.getTaskPoints(task);

      expect(points,
          3); // Based on the category order, academic is the highest priority.
    });

    test('completeTask should update currentPoints and completedTasks', () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task); // Add the task first

      pointsManager.completeTask(task);

      expect(pointsManager.currentPoints, greaterThan(0));
      expect(pointsManager.completedTasks.contains(task.id), isTrue);
    });

    test('removeTask should update maxPoints and currentPoints', () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task); // Add the task first
      pointsManager.removeTask(task);

      expect(pointsManager.maxPoints,
          greaterThanOrEqualTo(0)); // maxPoints should not go below 0
      expect(pointsManager.currentPoints,
          greaterThanOrEqualTo(0)); // currentPoints should not go below 0
    });

    test(
        'calculatePointsToPass should update pointsToPass based on maxPoints and difficulty',
        () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task); // Add a task to increase maxPoints
      pointsManager.calculatePointsToPass();

      expect(
          pointsManager.pointsToPass,
          greaterThan(
              0)); // pointsToPass should be greater than 0 after task is added
    });

    test('determinePass should return true if currentPoints >= pointsToPass',
        () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.completeTask(task);

      bool result = pointsManager.determinePass();

      expect(result, isTrue);
    });
  });
}

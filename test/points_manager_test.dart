import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_75/Components/points_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';

class MockAccountManager extends Mock implements AccountManager {}

void main() {
  group('PointsManager Comprehensive Tests', () {
    late PointsManager pointsManager;
    late MockAccountManager mockAccountManager;

    setUp(() {
      mockAccountManager = MockAccountManager();
      when(() => mockAccountManager.getDifficulty())
          .thenReturn(Difficulty.medium);
      when(() => mockAccountManager.getCategoryOrder()).thenReturn([
        TaskCategory.academic,
        TaskCategory.social,
        TaskCategory.hobby,
      ]);

      pointsManager = PointsManager(
        initialSchedule: Schedule(tasks: []),
        accountManager: mockAccountManager,
      );
    });

    // Task Addition Scenarios
    test(
        'Adding a valid task should update maxPoints and pointsToPass correctly',
        () {
      var task = TaskModel(
        id: 1,
        name: "Test Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.high,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);

      expect(pointsManager.maxPoints, greaterThan(0));
      expect(pointsManager.pointsToPass, greaterThan(0));
    });

    test('Adding overlapping task should not be allowed', () {
      var task1 = TaskModel(
        id: 1,
        name: "Task 1",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.high,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      var task2 = TaskModel(
        id: 2,
        name: "Task 2",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now().add(Duration(minutes: 30)),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task1);

      expect(() => pointsManager.addTask(task2), throwsException);
    });

    // Task Completion Scenarios
    test(
        'Completing a task should increase currentPoints and add to completedTasks',
        () {
      var task = TaskModel(
        id: 1,
        name: "Complete Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.completeTask(task);

      expect(pointsManager.currentPoints, greaterThan(0));
      expect(pointsManager.completedTasks.contains(task.id), isTrue);
    });

// testing for completing multiple tasks
    test(
        'testing for completing multiple tasks should increase currentPoints and add to completedTasks',
        () {
      var task1 = TaskModel(
        id: 1,
        name: "Complete Task 1",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      var task2 = TaskModel(
        id: 2,
        name: "Complete Task 2",
        isMovable: true,
        category: TaskCategory.social,
        priority: TaskPriority.high,
        startTime: DateTime.now().add(Duration(hours: 2)),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task1);
      pointsManager.addTask(task2);

      pointsManager.completeTask(task1);
      pointsManager.completeTask(task2);

      expect(pointsManager.currentPoints, greaterThan(0));
      expect(pointsManager.completedTasks.contains(task1.id), isTrue);
      expect(pointsManager.completedTasks.contains(task2.id), isTrue);
      expect(pointsManager.completedTasks.length, equals(2));
    });

    test('Completing a non-existent task should not change points', () {
      var task = TaskModel(
        id: 999,
        name: "Non-existent Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      expect(() => pointsManager.completeTask(task), throwsException);
    });

    // Task Removal Scenarios
    test('Removing a completed task should decrease currentPoints', () {
      var task = TaskModel(
        id: 1,
        name: "Task to Remove",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.completeTask(task);
      pointsManager.removeTask(task);

      expect(pointsManager.currentPoints, equals(0));
    });

    // Points Calculation Scenarios
    test('Points calculation based on category order', () {
      var task = TaskModel(
        id: 1,
        name: "Category Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      int points = pointsManager.getTaskPoints(task);
      expect(points, equals(3));
    });

    test('Points calculation based on priority', () {
      var taskLow = TaskModel(
        id: 1,
        name: "Low Priority Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.low,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      var taskHigh = TaskModel(
        id: 2,
        name: "High Priority Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.high,
        startTime: DateTime.now().add(Duration(hours: 2)),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(taskLow);
      pointsManager.addTask(taskHigh);

      expect(pointsManager.getTaskPoints(taskLow),
          lessThan(pointsManager.getTaskPoints(taskHigh)));
    });

    // Pass/Fail Determination
    test('determinePass should return true if currentPoints >= pointsToPass',
        () {
      var task = TaskModel(
        id: 1,
        name: "Pass Task",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.completeTask(task);

      expect(pointsManager.determinePass(), isTrue);
    });

    test('determinePass should return false if currentPoints < pointsToPass',
        () {
      expect(pointsManager.determinePass(), isFalse);
    });

    // Edge Cases
    test('Adding multiple tasks with varying durations and categories', () {
      var task1 = TaskModel(
        id: 1,
        name: "Task 1",
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.low,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      var task2 = TaskModel(
        id: 2,
        name: "Task 2",
        isMovable: true,
        category: TaskCategory.social,
        priority: TaskPriority.high,
        startTime: DateTime.now().add(Duration(hours: 2)),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task1);
      pointsManager.addTask(task2);

      expect(pointsManager.maxPoints, greaterThan(0));
      expect(pointsManager.pointsToPass, greaterThan(0));
    });

    test('Removing all tasks should reset maxPoints and currentPoints', () {
      pointsManager.maxPoints = 10;
      pointsManager.currentPoints = 5;

      pointsManager.removeTask(TaskModel(
          id: 1,
          name: "Task",
          isMovable: true,
          category: TaskCategory.academic,
          priority: TaskPriority.medium,
          startTime: DateTime.now(),
          duration: Duration(hours: 1)));

      expect(pointsManager.maxPoints, equals(0));
      expect(pointsManager.currentPoints, equals(0));
    });
  });
}

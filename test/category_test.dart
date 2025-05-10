import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';

class MockAccountManager extends Mock implements AccountManager {
  @override
  List<TaskCategory> getCategoryOrder() {
    return [
      TaskCategory.academic,
      TaskCategory.social,
      TaskCategory.health,
      TaskCategory.employment,
      TaskCategory.chore,
      TaskCategory.hobby,
    ];
  }
}

void main() {
  group('Category Page and Task Creation - Extensive Testing', () {
    late MockAccountManager mockAccountManager;

    setUp(() {
      mockAccountManager = MockAccountManager();
    });

    test(
        'Category order is correctly fetched from MockAccountManager (Successful)',
        () {
      final categories = mockAccountManager.getCategoryOrder();
      expect(
          categories,
          equals([
            TaskCategory.academic,
            TaskCategory.social,
            TaskCategory.health,
            TaskCategory.employment,
            TaskCategory.chore,
            TaskCategory.hobby,
          ]));
    });

    test('Category order is incorrectly fetched (Unsuccessful)', () {
      when(() => mockAccountManager.getCategoryOrder()).thenReturn([
        TaskCategory.hobby,
        TaskCategory.chore,
        TaskCategory.employment,
      ]);

      final categories = mockAccountManager.getCategoryOrder();
      expect(
        categories,
        isNot([
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
        ]),
      );
    });

    test('Task is created with correct category (Successful)', () {
      final task = TaskModel(
        id: 1,
        name: "Academic Task",
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      expect(task.category, TaskCategory.academic);
    });

    test('Task is created with incorrect category (Unsuccessful)', () {
      expect(
        () => TaskModel(
          id: 2,
          name: "Invalid Task",
          category: TaskCategory.values[100], // Invalid category index
          priority: TaskPriority.low,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true,
        ),
        throwsRangeError,
      );
    });

    test('Task creation with overlapping times (Unsuccessful)', () {
      final startTime = DateTime.now();
      final task1 = TaskModel(
        id: 1,
        name: "Task 1",
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: startTime,
        duration: Duration(hours: 1),
        isMovable: true,
      );

      final task2 = TaskModel(
        id: 2,
        name: "Task 2",
        category: TaskCategory.social,
        priority: TaskPriority.high,
        startTime: startTime.add(Duration(minutes: 30)),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      expect(task1.endTime.isAfter(task2.startTime), isTrue);
    });

    test(
        'Category order remains consistent across multiple fetches (Successful)',
        () {
      final firstFetch = mockAccountManager.getCategoryOrder();
      final secondFetch = mockAccountManager.getCategoryOrder();
      expect(firstFetch, equals(secondFetch));
    });

    test(
        'Category order inconsistency when mock is reconfigured (Unsuccessful)',
        () {
      when(() => mockAccountManager.getCategoryOrder()).thenReturn([
        TaskCategory.hobby,
        TaskCategory.chore,
        TaskCategory.employment,
        TaskCategory.health,
        TaskCategory.social,
        TaskCategory.academic,
      ]);

      final categories = mockAccountManager.getCategoryOrder();
      expect(
        categories,
        isNot([
          TaskCategory.academic,
          TaskCategory.social,
          TaskCategory.health,
        ]),
      );
    });

    test('Task creation with very short duration (Successful)', () {
      final task = TaskModel(
        id: 3,
        name: "Quick Task",
        category: TaskCategory.hobby,
        priority: TaskPriority.low,
        startTime: DateTime.now(),
        duration: Duration(minutes: 5),
        isMovable: true,
      );

      expect(task.duration.inMinutes, equals(5));
    });

    test('Task creation with negative duration (Unsuccessful)', () {
      expect(
        () => TaskModel(
          id: 4,
          name: "Negative Duration Task",
          category: TaskCategory.chore,
          priority: TaskPriority.high,
          startTime: DateTime.now(),
          duration: Duration(minutes: -30),
          isMovable: true,
        ),
        throwsArgumentError,
      );
    });

    test('Task creation with max possible duration (Edge Case)', () {
      final task = TaskModel(
        id: 5,
        name: "All Day Task",
        category: TaskCategory.employment,
        priority: TaskPriority.high,
        startTime: DateTime.now(),
        duration: Duration(hours: 24),
        isMovable: true,
      );

      expect(task.duration.inHours, equals(24));
    });

    test('Task creation with low priority (Successful)', () {
      final task = TaskModel(
        id: 6,
        name: "Low Priority Task",
        category: TaskCategory.health,
        priority: TaskPriority.low,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      expect(task.priority, TaskPriority.low);
    });

    test('Task creation with invalid priority (Unsuccessful)', () {
      expect(
        () => TaskModel(
          id: 7,
          name: "Invalid Priority Task",
          category: TaskCategory.academic,
          priority: TaskPriority.values[100], // Invalid index
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true,
        ),
        throwsRangeError,
      );
    });

    test('Tasks with same category but different priorities', () {
      final task1 = TaskModel(
        id: 8,
        name: "Medium Priority Task",
        category: TaskCategory.health,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      final task2 = TaskModel(
        id: 9,
        name: "High Priority Task",
        category: TaskCategory.health,
        priority: TaskPriority.high,
        startTime: DateTime.now().add(Duration(hours: 2)),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      expect(task1.priority.index, lessThan(task2.priority.index));
    });
  });
}

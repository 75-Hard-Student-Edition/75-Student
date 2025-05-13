import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:student_75/Components/points_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';
import 'package:student_75/Components/schedule_manager/schedule.dart';

class MockAccountManager extends Mock implements AccountManager {}

void main() {
  group('PointsManager Tests', () {
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

    //check that adding a task updates the point limits
    test('addTask should increase maxPoints and update passing points', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 1',
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

    //Confirms category order affects the point value
    test('getTaskPoints should return correct score based on category order', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 2',
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      final result = pointsManager.getTaskPoints(task);
      expect(result, 3); // academic is first in category order
    });

    //ensure completing tasks adds to total points
    test('completeTask should add task points and mark it as done', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 3',
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

    //confirms removing a task adjusts total points
    test('removeTask should take away points and unmark the task', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 4',
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.removeTask(task);

      expect(pointsManager.maxPoints, greaterThanOrEqualTo(0));
      expect(pointsManager.currentPoints, greaterThanOrEqualTo(0));
    });

    //Checks that pass changes when maxPoints do
    test('calculatePointsToPass should recalculate pass requirement', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 5',
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.calculatePointsToPass();

      expect(pointsManager.pointsToPass, greaterThan(0));
    });
    
    //Verifies that user has enough points
    test('determinePass should return true when enough points are scored', () {
      final task = TaskModel(
        id: 1,
        name: 'Task 6',
        isMovable: true,
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
      );

      pointsManager.addTask(task);
      pointsManager.completeTask(task);

      final result = pointsManager.determinePass();
      expect(result, isTrue);
    });
  });
}

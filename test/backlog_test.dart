import 'package:test/test.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/backlog.dart';

void main() {
  group('Backlog Class Tests', () {
    test('enqueue() adds tasks in the correct order based on priority', () {
      final backlog = Backlog(initialTasks: []);

      final task1 = TaskModel(
          id: 1,
          name: 'Task 1',
          priority: TaskPriority.low,
          category: TaskCategory.academic,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      final task2 = TaskModel(
          id: 2,
          name: 'Task 2',
          priority: TaskPriority.high,
          category: TaskCategory.social,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      backlog.enqueue(task1);
      backlog.enqueue(task2);

      final tasks = backlog.peak(2);

      // Ensure task2 (higher priority) is before task1
      expect(tasks[0].id, 2);
      expect(tasks[1].id, 1);
    });

    test('dequeue() removes the highest priority task', () {
      final backlog = Backlog(initialTasks: []);

      final task1 = TaskModel(
          id: 1,
          name: 'Task 1',
          priority: TaskPriority.low,
          category: TaskCategory.academic,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);
      final task2 = TaskModel(
          id: 2,
          name: 'Task 2',
          priority: TaskPriority.high,
          category: TaskCategory.social,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      backlog.enqueue(task1);
      backlog.enqueue(task2);

      final dequeuedTask = backlog.dequeue();

      // Ensure task2 with higher priority is dequeued first
      expect(dequeuedTask.id, 2);
    });

    test('peak() returns top n tasks without removing them from the backlog',
        () {
      final backlog = Backlog(initialTasks: []);

      final task1 = TaskModel(
          id: 1,
          name: 'Task 1',
          priority: TaskPriority.low,
          category: TaskCategory.academic,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);
      final task2 = TaskModel(
          id: 2,
          name: 'Task 2',
          priority: TaskPriority.high,
          category: TaskCategory.social,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      backlog.enqueue(task1);
      backlog.enqueue(task2);

      final topTasks = backlog.peak(1);

      expect(topTasks[0].id, 2);
    });

    test('remove() removes a task by ID', () {
      final backlog = Backlog(initialTasks: []);

      final task1 = TaskModel(
          id: 1,
          name: 'Task 1',
          priority: TaskPriority.low,
          category: TaskCategory.academic,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);
      final task2 = TaskModel(
          id: 2,
          name: 'Task 2',
          priority: TaskPriority.high,
          category: TaskCategory.social,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      backlog.enqueue(task1);
      backlog.enqueue(task2);

      backlog.remove(1);

      final tasks = backlog.peak(1);

      expect(tasks[0].id, 2);
    });

    // test('age() increases the priority of all tasks in the backlog', () {
    //   final backlog = Backlog(initialTasks: []);

    //   final task1 = TaskModel(
    //       id: 1,
    //       name: 'Task 1',
    //       priority: TaskPriority.low,
    //       category: TaskCategory.academic,
    //       startTime: DateTime.now(),
    //       duration: Duration(hours: 1),
    //       isMovable: true);
    //   final task2 = TaskModel(
    //       id: 2,
    //       name: 'Task 2',
    //       priority: TaskPriority.medium,
    //       category: TaskCategory.social,
    //       startTime: DateTime.now(),
    //       duration: Duration(hours: 1),
    //       isMovable: true);

    //   backlog.enqueue(task1);
    //   backlog.enqueue(task2);

    //   backlog.age();

    //   final tasks = backlog.peak(2);

    //   expect(tasks[0].priority, TaskPriority.medium);
    // });

    test('getTask() retrieves a task by ID', () {
      final backlog = Backlog(initialTasks: []);

      final task1 = TaskModel(
          id: 1,
          name: 'Task 1',
          priority: TaskPriority.low,
          category: TaskCategory.academic,
          startTime: DateTime.now(),
          duration: Duration(hours: 1),
          isMovable: true);

      backlog.enqueue(task1);

      final retrievedTask = backlog.getTask(1);

      expect(retrievedTask.id, 1);
    });
  });
}

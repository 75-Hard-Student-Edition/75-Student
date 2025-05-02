import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:collection/collection.dart';

/// A class representing a backlog of tasks, which is a priority queue of tasks.
class Backlog {
  final HeapPriorityQueue<TaskModel> _queue =
      HeapPriorityQueue<TaskModel>((a, b) => a.priority.value.compareTo(b.priority.value));
  Backlog({required List<TaskModel> initialTasks}) {
    for (var task in initialTasks) {
      _queue.add(task);
    }
  }

  /// Adds a task to the backlog based on its priority.
  void enqueue(TaskModel task) => _queue.add(task);

  /// Removes the task with the highest priority from the backlog and returns it
  TaskModel dequeue() => _queue.removeFirst();

  /// Returns a list of the top [n] tasks in the backlog without removing them.
  List<TaskModel> peak(int n) {
    List<TaskModel> result = [];
    // Construct result by removing n elements from the queue
    for (var i = 0; i < n; i++) {
      if (_queue.isEmpty) {
        break;
      }
      result.add(_queue.removeFirst());
    }
    // Re-add the removed elements
    for (var task in result) {
      _queue.add(task);
    }

    // Return the result
    return result;
  }

  /// Removes a task from the backlog from a given [id]
  void remove(int id) {
    for (var task in _queue.toUnorderedList()) {
      if (task.id == id) {
        _queue.remove(task);
        return;
      }
    }
  }

  /// Increases the priority of all tasks in the backlog by one level.
  void age() {
    // Empty queue into a list
    List<TaskModel> tasks = [];
    while (_queue.isNotEmpty) {
      TaskModel task = dequeue();
      tasks.add(task);
    }

    // Age the tasks
    for (var task in tasks) {
      enqueue(task.copyWith(priority: TaskPriority.values[task.priority.index - 1]));
    }
  }

  /// Returns a task in the backlog from a given [id]
  TaskModel getTask(int id) => _queue.toUnorderedList().firstWhere(
        (task) => task.id == id,
        orElse: () => throw TaskNotFoundException("Task with id: $id not found in backlog."),
      );
}

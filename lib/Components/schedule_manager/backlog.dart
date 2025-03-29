import 'package:student_75/Components/schedule_manager/schedule_manager.dart';
import 'package:student_75/models/task_model.dart';
import 'package:collection/collection.dart';

class Backlog {
  final HeapPriorityQueue<TaskModel> _queue =
      HeapPriorityQueue<TaskModel>((a, b) => a.priority.value.compareTo(b.priority.value));
  Backlog({required List<TaskModel> initialTasks}) {
    for (var task in initialTasks) {
      _queue.add(task);
    }
  }

  void enqueue(TaskModel task) => _queue.add(task);

  TaskModel dequeue() => _queue.removeFirst();

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

  void remove(int id) {
    for (var task in _queue.toUnorderedList()) {
      if (task.id == id) {
        _queue.remove(task);
        return;
      }
    }
  }

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

  TaskModel getTask(int id) => _queue.toUnorderedList().firstWhere(
        (task) => task.id == id,
        orElse: () => throw TaskNotFoundException("Task with id: $id not found in backlog."),
      );
}

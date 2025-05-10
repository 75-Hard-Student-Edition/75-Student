import 'package:flutter_test/flutter_test.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/account_manager/account_manager.dart';

//the mock account manager returns a fixed list of categories
class MockAccountManager extends AccountManager {
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
  group('Category order and task creation tests', () {
    //checks that the categories are returned in the correct order
    test('Category order is correctly fetched', () {
      final accountManager = MockAccountManager();

      expect(accountManager.getCategoryOrder(), [
        TaskCategory.academic,
        TaskCategory.social,
        TaskCategory.health,
        TaskCategory.employment,
        TaskCategory.chore,
        TaskCategory.hobby,
      ]);
    });

    //checks that a task is assigned to the right category
    test('Task is created with correct category', () {
      final mockTask = TaskModel(
        id: 1,
        name: "Task 1",
        category: TaskCategory.academic,
        priority: TaskPriority.medium,
        startTime: DateTime.now(),
        duration: Duration(hours: 1),
        isMovable: true,
      );

      expect(mockTask.category, TaskCategory.academic);
    });
  });
}

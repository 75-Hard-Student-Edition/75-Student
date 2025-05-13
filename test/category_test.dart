// import 'package:flutter_test/flutter_test.dart';
// import 'package:student_75/models/task_model.dart';
// import 'package:student_75/Components/account_manager/account_manager.dart';
// import 'package:student_75/Components/points_manager.dart';
// import 'package:student_75/Components/schedule_manager/schedule.dart';
// import 'package:student_75/models/difficulty_enum.dart';

// class MockAccountManager extends AccountManager {
//   @override
//   List<TaskCategory> getCategoryOrder() {
//     return [
//       TaskCategory.academic,
//       TaskCategory.social,
//       TaskCategory.health,
//       TaskCategory.employment,
//       TaskCategory.chore,
//       TaskCategory.hobby,
//     ];
//   }
// }

// void main() {
//   group('Category Order and Task Creation Tests', () {
//     test('Category Order is correctly fetched', () {
//       final accountManager = MockAccountManager();

//       // Check that the category order matches the expected order
//       expect(accountManager.getCategoryOrder(), [
//         TaskCategory.academic,
//         TaskCategory.social,
//         TaskCategory.health,
//         TaskCategory.employment,
//         TaskCategory.chore,
//         TaskCategory.hobby,
//       ]);
//     });

//     test('Task is created with correct category', () {
//       final mockTask = TaskModel(
//         id: 1,
//         name: "Academic Task",
//         category: TaskCategory.academic,
//         priority: TaskPriority.medium,
//         startTime: DateTime.now(),
//         duration: Duration(hours: 1),
//         isMovable: true,
//       );

//       expect(mockTask.category, TaskCategory.academic);
//     });

//     test(
//       'Tasks from different categories handle overlap based on priority',
//       () {
//         final task1 = TaskModel(
//           id: 1,
//           name: "Social Task",
//           category: TaskCategory.social,
//           priority: TaskPriority.medium,
//           startTime: DateTime(2025, 1, 1, 10, 0),
//           duration: Duration(hours: 2),
//           isMovable: true,
//         );

//         final task2 = TaskModel(
//           id: 2,
//           name: "Academic Task",
//           category: TaskCategory.academic,
//           priority: TaskPriority.high,
//           startTime: DateTime(2025, 1, 1, 11, 0),
//           duration: Duration(hours: 2),
//           isMovable: true,
//         );

//         final schedule = Schedule(tasks: [task1, task2]);

//         // Check that the tasks are sorted by priority
//         schedule.sort();

//         // Expect task2 (academic) to be handled before task1 (social)
//         expect(schedule.tasks[0], task2);
//         expect(schedule.tasks[1], task1);
//       },
//     );

//     test('Task overlap handling prevents category conflict', () {
//       final task1 = TaskModel(
//         id: 1,
//         name: "Chore Task",
//         category: TaskCategory.chore,
//         priority: TaskPriority.low,
//         startTime: DateTime(2025, 1, 1, 10, 0),
//         duration: Duration(hours: 1),
//         isMovable: true,
//       );

//       final task2 = TaskModel(
//         id: 2,
//         name: "Health Task",
//         category: TaskCategory.health,
//         priority: TaskPriority.high,
//         startTime: DateTime(2025, 1, 1, 10, 30),
//         duration: Duration(hours: 1),
//         isMovable: true,
//       );

//       final schedule = Schedule(tasks: [task1, task2]);

//       // Check for overlap and priority handling
//       schedule.sort();

//       // Expect task2 (health) to be placed before task1 (chore)
//       expect(schedule.tasks[0], task2);
//       expect(schedule.tasks[1], task1);
//     });
//   });
// }

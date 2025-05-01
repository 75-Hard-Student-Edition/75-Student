// import 'package:flutter_test/flutter_test.dart';
// import 'package:student_75/models/task_model.dart';
// import 'package:student_75/Components/points_manager.dart';
// import 'package:student_75/Components/account_manager/account_manager.dart';
// import 'package:student_75/models/difficulty_enum.dart';
// import 'package:student_75/Components/schedule_manager/schedule.dart';

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

//   @override
//   Difficulty getDifficulty() {
//     return Difficulty.medium;
//   }
// }

// void main() {
//   test('PointsManager updates points correctly when task is completed', () {
//     final mockTask = TaskModel(
//       id: 1,
//       name: "Test Task",
//       isMovable: true,
//       category: TaskCategory.academic,
//       priority: TaskPriority.medium,
//       startTime: DateTime.now(),
//       duration: Duration(hours: 1),
//     );

//     // Initialize a schedule with the task
//     final schedule = Schedule(tasks: [mockTask]);

//     // Initialize the PointsManager with the mock schedule and account manager
//     final manager = PointsManager(
//       initialSchedule: schedule,
//       accountManager: MockAccountManager(),
//     );

//     expect(
//       manager.maxPoints,
//       6,
//     ); // Points should be 6 based on academic category
//     expect(manager.determinePass(), false); // Points are not enough to pass yet

//     // Mark the task as completed, which should update the points
//     manager.completeTask(mockTask);

//     expect(manager.currentPoints, 6); // Points should remain 6 after completion
//     expect(
//       manager.determinePass(),
//       true,
//     ); // Task completion should result in passing
//   });
// }

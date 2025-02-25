import 'package:student_75/models/task_model.dart';

class ScheduleGenerator {
  static List<TaskModel> generateSanitisedSchedule() {
    List<TaskModel> schedule = []; // databaseService.getSchedule(); or smtn
    if (schedule.isEmpty || schedule.length == 1) return schedule;

    schedule.sort((a, b) => a.startTime.compareTo(b.startTime));

    bool passIsClean = false;
    while (!passIsClean) {
      passIsClean = true;

      for (int i = 0; i < schedule.length - 1; i++) {
        TaskModel currentTask = schedule[i];
        TaskModel nextTask = schedule[i + 1];

        if (!currentTask.endTime.isAfter(nextTask.startTime)) {
          continue;
        }

        // Overlap detected
        passIsClean = false;
        List<TaskModel> newTasks = handleOverlap(currentTask, nextTask);
        schedule.removeAt(i);
        schedule.removeAt(i);
        schedule.insertAll(i, newTasks);
        break;
      }
    }
  }

  static List<TaskModel> handleOverlap(
      TaskModel currentTask, TaskModel nextTask) {}
}

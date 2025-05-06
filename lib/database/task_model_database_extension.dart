import 'package:student_75/models/task_model.dart';

extension TaskModelDB on TaskModel {
  Map<String, dynamic> toMap(int userId) {
    return {
      "task_id": id,
      "user_id": userId,
      "title": description,
      "description": description,
      "is_moveable": isMovable ? 1 : 0,
      "is_complete": isComplete ? 1 : 0,
      "category": TaskCategory.values.indexOf(category),
      "priority": TaskPriority.values.indexOf(priority),
      "start_time": startTime.toIso8601String(),
      "duration_minutes": duration.inMinutes,
      "repeat_period": period?.inDays.toString() ?? "",
      "links": links ?? ""
    };
  }

  static TaskModel fromMap(Map<String, dynamic> map) {
    print("TaskModelDB.fromMap: ${map.toString()}");
    final ret = TaskModel(
        id: map["task_id"],
        name: map["title"],
        description: map["description"],
        isMovable: map["is_moveable"] == 1,
        isComplete: map["is_complete"] == 1,
        category: TaskCategory.values[map["category"]],
        priority: TaskPriority.values[map["priority"]],
        startTime: DateTime.parse(map["start_time"]),
        duration: Duration(minutes: map["duration_minutes"]),
        period: map["period"] != "" ? Duration(minutes: map["period"]) : null,
        links: map["links"]);
    print("TaskModelDB.fromMap: ${ret.toString()}");
    return ret;
  }
}

import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/user_account_model.dart';
import 'package:student_75/models/difficulty_enum.dart';

extension UserAccountModelDB on UserAccountModel {
  String _categoryOrderToString(List<TaskCategory> categoryOrder) {
    return categoryOrder.map((e) => e.toString().split(".").last).join(",");
  }

  List<TaskCategory> _categoryOrderFromString(String categoryOrderStr) {
    return categoryOrderStr
        .split(",")
        .map((e) => TaskCategory.values
            .firstWhere((item) => item.toString().split(".").last == e))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": id,
      "username": username,
      "streak": streak,
      "email": email ?? "",
      "phone_number": phoneNumber ?? "",
      "difficulty": Difficulty.values.indexOf(difficulty!),
      "category_order": _categoryOrderToString(categoryOrder!),
      "sleep_duration_minutes": sleepDuration!.inMinutes,
      "bedtime": bedtime!.toIso8601String(),
      "notify_time_minutes": bedtimeNotifyBefore,
      "mindfulness_minutes": mindfulnessDuration!.inMinutes,
    };
  }
}

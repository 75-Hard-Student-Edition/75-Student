import 'package:flutter/material.dart'; // TimeOfDay

import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

class UserAccountModel {
  final int id;
  final String username;
  final int streak = 0;
  final Difficulty difficulty;
  final List<TaskCategory> categoryOrder;
  final Duration sleepDuration;
  final Map<String, TimeOfDay> bedtimes;
  final Duration bedtimeNotifyBefore;

  UserAccountModel({
    required this.id,
    required this.username,
    required this.difficulty,
    required this.categoryOrder,
    required this.sleepDuration,
    required this.bedtimes,
    required this.bedtimeNotifyBefore,
  });
}

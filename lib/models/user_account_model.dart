import 'package:flutter/material.dart'; // TimeOfDay
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/models/task_model.dart';

class UserAccountModel {
  final int id;
  final String username;

  final int streak = 0;
  final Difficulty? difficulty;
  final List<TaskCategory>? categoryOrder;

  final Duration? sleepDuration;
  final TimeOfDay? bedtime;
  final Duration? bedtimeNotifyBefore;

  final Duration? mindfulnessDuration;
  final Duration? taskNotifyBefore;

  UserAccountModel({
    required this.id,
    required this.username,
    required this.difficulty,
    required this.categoryOrder,
    required this.sleepDuration,
    required this.bedtime,
    required this.bedtimeNotifyBefore,
    required this.mindfulnessDuration,
    required this.taskNotifyBefore,
  }) {
    // Run input checks to validate the data
    _runInputChecks();
  }

  void _runInputChecks() {
    if (sleepDuration != null && sleepDuration!.inSeconds < 0) {
      throw ArgumentError('Sleep duration must be greater than or equal to 0');
    }
    if (bedtime != null &&
        (bedtime!.hour < 0 || bedtime!.hour > 23 || bedtime!.minute < 0 || bedtime!.minute > 59)) {
      throw ArgumentError('Bedtime must be a valid TimeOfDay');
    }
    if (bedtimeNotifyBefore != null && bedtimeNotifyBefore!.inSeconds < 0) {
      throw ArgumentError('Bedtime notify before must be greater than or equal to 0');
    }
    if (mindfulnessDuration != null && mindfulnessDuration!.inSeconds < 0) {
      throw ArgumentError('Mindfulness duration must be greater than or equal to 0');
    }
    if (taskNotifyBefore != null && taskNotifyBefore!.inSeconds < 0) {
      throw ArgumentError('Notify before must be greater than or equal to 0');
    }
  }

  UserAccountModel copyWith({
    int? id,
    String? username,
    int? streak,
    Difficulty? difficulty,
    List<TaskCategory>? categoryOrder,
    Duration? sleepDuration,
    TimeOfDay? bedtime,
    Duration? bedtimeNotifyBefore,
    Duration? mindfulnessDuration,
    Duration? taskNotifyBefore,
  }) {
    return UserAccountModel(
      id: id ?? this.id,
      username: username ?? this.username,
      difficulty: difficulty ?? this.difficulty,
      categoryOrder: categoryOrder ?? this.categoryOrder,
      sleepDuration: sleepDuration ?? this.sleepDuration,
      bedtime: bedtime ?? this.bedtime,
      bedtimeNotifyBefore: bedtimeNotifyBefore ?? this.bedtimeNotifyBefore,
      mindfulnessDuration: mindfulnessDuration ?? this.mindfulnessDuration,
      taskNotifyBefore: taskNotifyBefore ?? this.taskNotifyBefore,
    );
  }

  @override
  String toString() {
    return 'UserAccountModel{id: $id, username: $username, difficulty: $difficulty, categoryOrder: $categoryOrder, sleepDuration: $sleepDuration, bedtime: $bedtime, bedtimeNotifyBefore: $bedtimeNotifyBefore, taskNotifyBefore: $taskNotifyBefore, mindfulnessDuration: $mindfulnessDuration}';
  }
}

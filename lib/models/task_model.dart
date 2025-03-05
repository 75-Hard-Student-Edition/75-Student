import 'package:student_75/models/location_model.dart';

enum TaskPriority { low, medium, high }

enum TaskCategory { academic, social, health, employment, chore, hobby }

class TaskModel {
  final int id;
  final String name;
  final String description;

  final bool isMovable;
  bool isComplete;

  final TaskCategory category;
  final TaskPriority priority;
  final Location? location;

  final DateTime startTime;
  late final DateTime endTime;
  late final DateTime nextScheduled;
  final Duration? period;

  final Duration notifyBefore;

  TaskModel({
    required this.id,
    required this.name,
    this.description = '',
    required this.isMovable,
    this.isComplete = false,
    required this.category,
    required this.priority,
    this.location,
    required this.startTime,
    required Duration duration,
    this.period,
    this.notifyBefore = Duration.zero,
  }) {
    // Calculate end time and next scheduled time
    endTime = startTime.add(duration);
    nextScheduled = startTime.add(period ?? Duration.zero);

    _runInputChecks();
  }

  void _runInputChecks() {
    if (endTime.isBefore(startTime)) {
      throw ArgumentError('End time must be after start time');
    }
    if (nextScheduled.isBefore(startTime)) {
      throw ArgumentError('Next scheduled time must be after or start time');
    }
    if (period != null && period!.inSeconds <= 0) {
      throw ArgumentError('Period must be greater than 0');
    }
    if (notifyBefore.inSeconds < 0) {
      throw ArgumentError('Notify before must be greater than or equal to 0');
    }
  }

  TaskModel copyWith({
    String? name,
    String? description,
    bool? isMovable,
    bool? isComplete,
    TaskCategory? category,
    TaskPriority? priority,
    Location? location,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? nextScheduled,
    Duration? period,
    Duration? notifyBefore,
  }) {
    return TaskModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      isMovable: isMovable ?? this.isMovable,
      isComplete: isComplete ?? this.isComplete,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      duration:
          (endTime ?? this.endTime).difference(startTime ?? this.startTime),
      period: period ?? this.period,
      notifyBefore: notifyBefore ?? this.notifyBefore,
    );
  }
}

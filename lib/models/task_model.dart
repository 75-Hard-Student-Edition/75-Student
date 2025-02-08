class TaskCategory {/* Stub implementation of TaskCategory */}

class Location {/* Stub implementation of Location */}

enum TaskPriority { low, medium, high }

class Task {
  final int id;
  final String name;
  final String description;

  final bool isMovable;
  final bool isComplete = false;

  final TaskCategory category;
  final TaskPriority priority;
  final Location? location;

  final DateTime startTime;
  late final DateTime endTime;
  late final DateTime nextScheduled;
  final Duration? period;

  final Duration notifyBefore;

  Task({
    required this.id,
    required this.name,
    this.description = '',
    required this.isMovable,
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
}

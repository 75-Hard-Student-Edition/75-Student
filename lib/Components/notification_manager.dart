import 'package:student_75/models/task_notification.dart';

class Task {/* Stub implementation of Task */}

abstract class ApiInterface {
  // Stub implementation of API interface
  void setNotification(notification);
  void removeNotification(int taskId);
}

class NotificationManager implements ApiInterface {
  // Instance variable to hold a list of TaskNotification objects
  List<TaskNotification> notifications;

  NotificationManager({required this.notifications});

  // Method to add a notification for a task (empty for now)
  void addNotification(Task task) {}

  // API method to set a notification via an external interface (empty for now)
  @override
  void setNotification(notification) {}

  // API Method to remove a notification based on task ID via an external interface
  @override
  void removeNotification(int taskId) {}
}

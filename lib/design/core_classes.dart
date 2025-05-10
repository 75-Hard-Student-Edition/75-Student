const Duration DURATION_TO_AGE_TASK = Duration(days: 1);
const double DEFAULT_LOCATION_RADIUS = 100.0;

enum CategoryType { academic, social, health, employment, chore, hobby }

class Category {
  CategoryType type;
  int cost; // Number of points gained for completeing a task of this category

  Category({required this.type, required this.cost});
}

class Location {
  String name;
  double latitude;
  double longitude;
  double radius;

  Location(
      {required this.name,
      required this.latitude,
      required this.longitude,
      this.radius = DEFAULT_LOCATION_RADIUS});
}

enum Priority {
  low(1),
  medium(2),
  high(3);

  final int value;
  const Priority(this.value);
}

class Task {
  final String name;
  final Category category;
  Priority priority;
  Location? location;

  DateTime lastAged = DateTime.now();
  DateTime startTime;
  DateTime endTime;
  DateTime? reminderTime;

  bool isMovable = true;
  bool isComplete = false;

  Task({
    required this.name,
    required this.category,
    required this.priority,
    required this.startTime,
    required this.endTime,
    Duration? remindBefore,
  }) : reminderTime = startTime.subtract(remindBefore ?? Duration.zero);

  // Would need getters and setters for all attributes

  void complete() {
    if (/* location && currentLocation == location */ true) isComplete = true;
  }

  void remind() {
    if (DateTime.now().isAtSameMomentAs(reminderTime!)) {
      // Send notification
    }
  }

  void age() {
    if (DateTime.now().difference(lastAged) >= DURATION_TO_AGE_TASK) {
      lastAged = DateTime.now();
      priority = Priority.values[priority.value + 1];
      // Callback to schedule handler to reorganize tasks
    }
  }
}

class DailySchedule {
  List<Task> tasks = [];
  DateTime bedtime;
  int maxPoints = 0;
  int currentPoints = 0;

  DailySchedule({required this.bedtime});

  void importRecurringTasks(DateTime date) {
    // Import tasks from database?
  }

  void importCalanderTasks(DateTime date) {
    // Import tasks from calander?
  }

  void addTask(Task task) {
    // Need more logic about what time to put tasks in
    tasks.add(task);
    maxPoints += task.category.cost;
  }

  void removeTask(Task task) => tasks.remove(task);

  void completeTask(Task task) {
    task.complete();
    currentPoints += task.category.cost;
  }
}

class ScheduleHandler {
  //! Need a way to determine bedtime - user settings or algorithmic?
  DateTime? bedtime;
  late DailySchedule today;
  late DailySchedule tomorrow;
  //! Need to be able to write backlog to the database as well, in case of logout
  Backlog backlog = Backlog();

  ScheduleHandler() {
    today = DailySchedule(bedtime: bedtime!);
    tomorrow = DailySchedule(bedtime: bedtime!);
  }

  void importTasks() {
    today.importRecurringTasks(DateTime.now());
    today.importCalanderTasks(DateTime.now());
  }

  void postPoneTask(Task task, bool toTomorrow) {
    today.removeTask(task);
    if (toTomorrow) {
      tomorrow.addTask(task);
    } else {
      backlog.addTask(task);
    }
  }

  void nextDay() {
    today = tomorrow;
    tomorrow = DailySchedule(bedtime: bedtime!);
  }
}

class Backlog {
  List<Task> tasks = [];

  void addTask(Task task) {
    for (int i = 0; i < tasks.length; i++) {
      Task currentTask = tasks[i];
      if (currentTask.priority.value < task.priority.value) {
        tasks.insert(i, task);
        return;
      }
    }
    tasks.add(task);
  }

  void removeTask(Task task) => tasks.remove(task);

  Task popTask() => tasks.removeAt(0);
}

enum Difficulty { easy, medium, hard }

class UserAccount {
  late final String username;
  int streak = 0;
  late Difficulty difficulty;

  UserAccount() {
    fetchUserDetails();
  }

  void fetchUserDetails() {
    // Fetch details from database
    username = "temp";
    streak = 0;
    difficulty = Difficulty.easy;
  }

  void incrementStreak() {
    streak++;
  }
}

/// Acts as an interface between the app, database, and userAccount
class UserAccountHandler {
  UserAccount? account;

  void login(String username, String password) {
    // Fetch username and password from database
    String fetchedUsername = "temp";
    //* Note: important not to store fetchedPassword in a variable
    String fetchedPassword = "temp";
    if (username == fetchedUsername && password == fetchedPassword) account = UserAccount();
  }

  void signUp(String username, String password) {
    // Push username, password, streak = 0, and categories order to database
    login(username, password);
  }
}

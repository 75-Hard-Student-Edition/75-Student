import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/Components/schedule_manager/schedule_manager.dart';

class AddTaskScreen extends StatefulWidget {
  final ScheduleManager scheduleManager;
  final TaskModel? initialTask;
  const AddTaskScreen({super.key, required this.scheduleManager, this.initialTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState(scheduleManager, initialTask: initialTask);
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final ScheduleManager scheduleManager;
  String _selectedTime = "00:00";
  String _endTime = "00:00";
  int _selectedDuration = 0;
  String _location = "";
  String _notes = "";
  DateTime _selectedDate = DateTime.now();
  String _links = "";
  String _taskName = "";
  Color _selectedCategoryColor = const Color(0xFFDCF0EE);
  Color _selectedCategoryBorderColor = const Color(0xFF56C1B7);
  final Color _textColor = const Color(0xFFFFFFFF);

  final TaskModel? initialTask;
  _AddTaskScreenState(this.scheduleManager, {this.initialTask});
  TaskCategory? _selectedCategory;
  String? _selectedRepeatOption;
  final bool _isMovable = false;
  final bool _isComplete = false;
  Duration? _period; 
  //Location? _taskLocation;

  List<TaskModel> taskList = [];

  void saveTask(TaskModel task) {
    taskList.add(task);
    print("Task Saved: ${task.name}");
  }

  @override
  void initState() {
    super.initState();
    if (initialTask != null) {
      _taskName = initialTask!.name;
      _notes = initialTask!.description;
      _selectedDate = initialTask!.startTime;
      _selectedTime = DateFormat('HH:mm').format(initialTask!.startTime);
      _selectedDuration = initialTask!.duration.inMinutes;
      _endTime = DateFormat('HH:mm').format(initialTask!.startTime.add(initialTask!.duration));
      _selectedCategory = initialTask!.category;
      
      // Update colors to match selected category
      switch (_selectedCategory!) {
        case TaskCategory.academic:
          _selectedCategoryColor = lightenColor(const Color(0xFF00BCD4), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFF00BCD4), 0.2);
          break;
        case TaskCategory.social:
          _selectedCategoryColor = lightenColor(const Color(0xFF8AD483), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFF8AD483), 0.2);
          break;
        case TaskCategory.health:
          _selectedCategoryColor = lightenColor(const Color(0xFFF67373), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFFF67373), 0.2);
          break;
        case TaskCategory.chore:
          _selectedCategoryColor = lightenColor(const Color(0xFFE997CD), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFFE997CD), 0.2);
          break;
        case TaskCategory.hobby:
          _selectedCategoryColor = lightenColor(const Color(0xFF946AAE), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFF946AAE), 0.2);
          break;
        case TaskCategory.employment:
          _selectedCategoryColor = lightenColor(const Color(0xFFEDBF45), 0.4);
          _selectedCategoryBorderColor = darkenColor(const Color(0xFFEDBF45), 0.2);
          break;
      }
      
      _location = initialTask!.location?.name ?? '';
      _period = initialTask!.period;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

      return SafeArea(
    child: Container(
      height: screenHeight * 0.8,  
      decoration: BoxDecoration(
        color: _selectedCategoryColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _selectedCategoryBorderColor, width: 5),
      ),
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              _buildDateSelector(),
              _buildTaskNameInput(),
              _buildTimeSelectors(),
              _buildDurationSelector(),
              _buildCategorySelector(),
              _buildRepeatOptions(),
              _buildLocationNotesLinks(),
              SizedBox(child: _buildSaveCancelButtons(context)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCupertinoInputDialog(
      String title, Function(String) onSave) async {
    TextEditingController controller = TextEditingController();

    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            "Enter $title",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            children: [
              const SizedBox(height: 10),
              CupertinoTextField(
                controller: controller,
                placeholder: title,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel",
                  style: TextStyle(color: Color(0xFFE05151))),
            ),
            CupertinoDialogAction(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
              child: const Text("Enter",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFF43AB37))),
            ),
          ],
        );
      },
    );
  }

  /// Task Name Input
  Widget _buildTaskNameInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: GestureDetector(
        onTap: () => _showCupertinoInputDialog("Task Name", (value) {
          setState(() {
            _taskName = value;
          });
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Task Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'kdamThmorPro',
                color: _textColor,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: const Offset(1, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _taskName.isNotEmpty
                ? Text(_taskName, style: const TextStyle(fontSize: 14))
                : Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedCategoryColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(4, 4),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 10),
            Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
          ],
        ),
      ),
    );
  }

  Color lightenColor(Color color, double amount) {
    double adjustedAmount = amount * 1.5;
    if (adjustedAmount > 1) {
      adjustedAmount = 1;
    }
    return Color.fromRGBO(
      (color.red + ((255 - color.red) * adjustedAmount)).round(),
      (color.green + ((255 - color.green) * adjustedAmount)).round(),
      (color.blue + ((255 - color.blue) * adjustedAmount)).round(),
      1,
    );
  }

  Color darkenColor(Color color, double amount) {
    return Color.fromRGBO(
      (color.red * (1 - amount)).round(),
      (color.green * (1 - amount)).round(),
      (color.blue * (1 - amount)).round(),
      1,
    );
  }

  /// Add New Task header
  Widget _buildHeader(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: _selectedCategoryBorderColor,
          //border: Border.all(color: _selectedCategoryBorderColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF545454),
              offset: Offset(0, 0),
              blurRadius: 6,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
        child: const Text(
          "Add New Task",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'kdamThmorPro',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            // Done
            SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Divider(thickness: 1.5, color: Color(0xFFD0D0D0)),
            // Cupertino Date Picker
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                mode: CupertinoDatePickerMode.date,
                minimumDate: DateTime(2000),
                maximumDate: DateTime(2100),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Date Selector
  Widget _buildDateSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _showCupertinoDatePicker(context),
            child: const Icon(Icons.calendar_today, color: Color(0xFFBABABA)),
          ),
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBABABA), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              DateFormat('dd/MM/yyyy').format(_selectedDate),
              style: const TextStyle(
                  fontFamily: 'kdamThmorPro',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFBABABA)),
            ),
          ),
        ],
      ),
    );
  }

  /// Start Time & End Time Selector
  Widget _buildTimeSelectors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Start Time",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'kdamThmorPro',
              color: _textColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _buildTimePicker(false),
          const SizedBox(width: 10),
          Container(
            height: 1.5,
            width: 20,
            color: const Color(0xFFD0D0D0),
          ),
          const SizedBox(width: 10),
          _buildTimePicker(true),
        ],
      ),
    );
  }

  Widget _buildTimePicker(bool isGreen) {
    return GestureDetector(
      onTap: () async {
        if (!isGreen) {
          String? selectedTime = await _showTimePickerModal();
          if (selectedTime != null) {
            setState(() {
              _selectedTime = selectedTime;
            });
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 167, 167, 167),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              isGreen ? _endTime : _selectedTime,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isGreen ? _selectedCategoryBorderColor : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Time scrollable with 15-minute intervals
  Future<String?> _showTimePickerModal() async {
    int selectedHour = TimeOfDay.now().hour;
    int selectedMinute = (TimeOfDay.now().minute ~/ 15) * 15;

    return await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Cancel
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[300],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        String formattedTime =
                            "${selectedHour.toString().padLeft(2, '0')}:${selectedMinute.toString().padLeft(2, '0')}";
                        Navigator.pop(context, formattedTime);
                      },
                      //Save
                      child: Text("Save",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[300],
                          )),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.5, color: Color(0xFFE0E0E0)),
              // time picker
              SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // hours
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedHour),
                        onSelectedItemChanged: (int index) {
                          selectedHour = index;
                        },
                        children: List<Widget>.generate(
                          24,
                          (int index) => Center(
                              child: Text(index.toString().padLeft(2, '0'))),
                        ),
                      ),
                    ),
                    const Text(":",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    // minutes
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(
                            initialItem: selectedMinute ~/ 15),
                        onSelectedItemChanged: (int index) {
                          selectedMinute = index * 15;
                        },
                        children: const [
                          Center(child: Text("00")),
                          Center(child: Text("15")),
                          Center(child: Text("30")),
                          Center(child: Text("45")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Duration Selector
  Widget _buildDurationSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
          const SizedBox(height: 10),
          Text(
            "Duration",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'kdamThmorPro',
              color: _textColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _selectedCategoryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDurationButton("15m", 15),
                    const SizedBox(width: 5),
                    _buildDurationButton("30m", 30),
                    const SizedBox(width: 5),
                    _buildDurationButton("45m", 45),
                    const SizedBox(width: 5),
                    _buildDurationButton("1 hr", 60),
                    const SizedBox(width: 5),
                    _buildDurationButton("1.5 hr", 90),
                    const SizedBox(width: 5),
                    _buildDurationButton("2 hr", 120),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
        ],
      ),
    );
  }

  Widget _buildDurationButton(String label, int duration) {
    bool isSelected = _selectedDuration == duration;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDuration = duration;
          List<String> parts = _selectedTime.split(':');
          int hour = int.parse(parts[0]);
          int minute = int.parse(parts[1]);
          int totalMinutes = hour * 60 + minute + duration;
          int newHour = (totalMinutes ~/ 60) % 24;
          int newMinute = totalMinutes % 60;
          _endTime =
              "${newHour.toString().padLeft(2, '0')}:${newMinute.toString().padLeft(2, '0')}";
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? darkenColor(_selectedCategoryBorderColor, 0.2)
              : _selectedCategoryBorderColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ]
              : [],
          //border: Border.all(color: _selectedCategoryBorderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Category Selector
  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            "Category",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'kdamThmorPro',
              color: _textColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryChip("Academic", const Color(0xFF00BCD4),
                      TaskCategory.academic),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                      "Social", const Color(0xFF8AD483), TaskCategory.social),
                  const SizedBox(width: 8),
                  _buildCategoryChip(
                      "Health", const Color(0xFFF67373), TaskCategory.health),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCategoryChip(
                      "Chore", const Color(0xFFE997CD), TaskCategory.chore),
                  const SizedBox(width: 8),
                  _buildCategoryChip("Hobby", const Color(0xFF946AAE), TaskCategory.hobby),
                  const SizedBox(width: 8),
                  _buildCategoryChip("Employment", const Color(0xFFEDBF45),
                      TaskCategory.employment),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, Color color, TaskCategory category) {
    bool isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategory == category) {
            _selectedCategory = null;
            _selectedCategoryColor = const Color(0xFFDCF0EE);
            _selectedCategoryBorderColor = const Color(0xFF56C1B7);
          } else {
            _selectedCategory = category;
            _selectedCategoryColor = lightenColor(color, 0.4);
            _selectedCategoryBorderColor = darkenColor(color, 0.2);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? darkenColor(color, 0.2) : color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// Repeat Options
  Widget _buildRepeatOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
          const SizedBox(height: 10),
          Text(
            "Repeat",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'kdamThmorPro',
              color: _textColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: const Offset(1, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _selectedCategoryColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildRepeatButton("Once", Duration.zero),
                    const SizedBox(width: 5),
                    _buildRepeatButton("Weekly", const Duration(days: 7)),
                    const SizedBox(width: 5),
                    _buildRepeatButton("Fortnightly", const Duration(days: 14)),
                    const SizedBox(width: 5),
                    _buildRepeatButton("Monthly", const Duration(days: 30)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(thickness: 1.5, color: _selectedCategoryBorderColor)
        ],
      ),
    );
  }

  Widget _buildRepeatButton(String label, Duration period) {
    bool isSelected = _selectedRepeatOption == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRepeatOption = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? darkenColor(_selectedCategoryBorderColor, 0.2)
              : _selectedCategoryBorderColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ]
              : [],
          border: Border.all(color: _selectedCategoryBorderColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationNotesLinks() {
    return Column(
      children: [
        // Location
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: GestureDetector(
            onTap: () => _showCupertinoInputDialog("Location", (value) {
              setState(() {
                _location = value;
              });
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kdamThmorPro',
                    color: _textColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _location.isNotEmpty
                    ? Text(_location, style: const TextStyle(fontSize: 14))
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedCategoryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 10),
                Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Notes
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: GestureDetector(
            onTap: () => _showCupertinoInputDialog("Notes", (value) {
              setState(() {
                _notes = value;
              });
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kdamThmorPro',
                    color: _textColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _notes.isNotEmpty
                    ? Text(_notes, style: const TextStyle(fontSize: 14))
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedCategoryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 10),
                Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Links
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: GestureDetector(
            onTap: () => _showCupertinoInputDialog("Links", (value) {
              setState(() {
                _links = value;
              });
            }),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Links",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'kdamThmorPro',
                    color: _textColor,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                _links.isNotEmpty
                    ? Text(_links, style: const TextStyle(fontSize: 14))
                    : Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: _selectedCategoryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              offset: const Offset(4, 4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                const SizedBox(height: 10),
                Divider(thickness: 1.5, color: _selectedCategoryBorderColor),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Save & Cancel Buttons
  Widget _buildSaveCancelButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC73A3A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "DISCARD",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34A234),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (_taskName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Task name cannot be empty!")),
                );
                return;
              }

              if (_selectedCategory == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a category!")),
                );
                return;
              }

              if (_selectedDuration <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Please select a valid duration!")),
                );
                return;
              }

              DateTime startTime = DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                int.parse(_selectedTime.split(":")[0]),
                int.parse(_selectedTime.split(":")[1]),
              );

              int taskId = DateTime.now().millisecondsSinceEpoch;

              TaskModel newTask = TaskModel(
                id: taskId,
                name: _taskName,
                description: _notes,
                isMovable: _isMovable,
                isComplete: _isComplete,
                category: _selectedCategory!,
                priority: TaskPriority.medium,
                //location: _location.isNotEmpty ? Location(name: _location) : null,
                startTime: startTime,
                duration: Duration(minutes: _selectedDuration),
                period: _period, 
              );

              print("Saving Task:");
              print("ID: ${newTask.id}");
              print("Name: ${newTask.name}");
              print("Start Time: ${newTask.startTime}");
              print("Duration: ${newTask.duration.inMinutes} minutes");
              print("Category: ${newTask.category}");
              print("Repeat (Period): ${newTask.period?.inDays ?? 0} days");
              print("Location: ${newTask.location?.name ?? 'No location'}");
              print("Notes: ${newTask.description}");

            
              if (initialTask != null) {
                TaskModel updatedTask = TaskModel(
                  id: initialTask!.id,
                  name: newTask.name,
                  description: newTask.description,
                  isMovable: newTask.isMovable,
                  isComplete: newTask.isComplete,
                  category: newTask.category,
                  priority: newTask.priority,
                  startTime: newTask.startTime,
                  duration: newTask.duration,
                  period: newTask.period,
                  location: newTask.location,
                );
                scheduleManager.editTask(updatedTask);
                Navigator.pop(context, updatedTask);
              } else {
                scheduleManager.addTask(newTask);
                Navigator.pop(context, newTask);
              }
            },
            child: const Text(
              "SAVE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

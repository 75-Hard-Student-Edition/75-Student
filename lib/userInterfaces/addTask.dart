import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: screenHeight * 0.95,
      decoration: BoxDecoration(
        color: const Color(0xFFDCF0EE), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF56C1B7), width: 5), 
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(context),
          _buildDateSelector(),
          _buildTimeSelectors(),
          _buildDurationSelector(),
          _buildCategorySelector(),
          _buildRepeatOptions(),
          _buildLocationNotesLinks(),
          _buildSaveCancelButtons(context),
        ],
      ),
    );
  }

  /// Add New Task header
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF56C1B7),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color:  Color(0xFF545454),
            offset: Offset(0, 0),
            blurRadius: 6,
          ), 
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: const Text(
        "Add New Task",
        style: TextStyle(
          fontFamily: 'kdamThmorPro',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
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
          const Icon(Icons.calendar_today, color: Color(0xFFBABABA)), 
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBABABA), width: 1.5),
              borderRadius: BorderRadius.circular(8), 
            ),
            child: const Text(
              "26/01/2025",
              style: TextStyle(
                fontFamily: 'kdamThmorPro',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFFBABABA) 
            ),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Text("Time: ", style: TextStyle(color: Colors.grey[700], fontFamily: 'kdamThmorPro'),),
              const SizedBox(width: 5), 
              _buildTimePicker("12:00"), 
              _buildTimePicker("12:45"), 
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTimePicker(String time) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(time, style: const TextStyle(fontSize: 16)),
    );
  }

  /// Duration Selector
  Widget _buildDurationSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Duration", style: TextStyle(fontSize: 16)), 
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Wrap(
              spacing: 5,
              children: [
                _buildDurationButton("15m", 15),
                _buildDurationButton("30m", 30),
                _buildDurationButton("45m", 45),
                _buildDurationButton("1 hr", 60),
                _buildDurationButton("1.5 hr", 90),
                _buildDurationButton("2 hr", 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(String label, int duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  /// Category Selector
  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryChip("Academic",const Color(0xFF81E4F0)),
              const SizedBox(width: 10),
              _buildCategoryChip("Social", const Color(0xFF8AD483)),
              const SizedBox(width: 10),
              _buildCategoryChip("Health", const Color(0xFFFF4F4F)),
            ],
          ),
          const SizedBox(height: 10), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryChip("Employment", const Color(0xFFEDBF45)),
              const SizedBox(width: 10),
              _buildCategoryChip("Chore", const Color(0xFFE997CD)),
              const SizedBox(width: 10),
              _buildCategoryChip("Hobby", Colors.cyan),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildCategoryChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  /// Repeat Options
  Widget _buildRepeatOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Repeat", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Wrap(
              spacing: 10,
              children: [
                _buildRepeatButton("Once"),
                _buildRepeatButton("Weekly"),
                _buildRepeatButton("Fortnightly"),
                _buildRepeatButton("Monthly"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }

  /// Location, Notes, Links Input
  Widget _buildLocationNotesLinks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          _buildTextInput("Location"),
          _buildTextInput("Notes"),
          _buildTextInput("Links"),
        ],
      ),
    );
  }

  Widget _buildTextInput(String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
        ),
      ),
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
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {}, // no backend logic yet
            child: const Text("Save Task"),
          ),
        ],
      ),
    );
  }
}
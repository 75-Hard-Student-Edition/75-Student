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
        color: Color(0xFFB2DFDB), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color.fromARGB(255, 3, 138, 116), width: 5), 
      ),
      padding: EdgeInsets.all(16),
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
        color: const Color.fromARGB(255, 21, 172, 124),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 20, 79, 69),
            offset: Offset(0, 0),
            blurRadius: 6,
          ), 
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(
        "Add New Task",
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Date Selector
  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Icon(Icons.calendar_today, color: Colors.white), 
        SizedBox(width: 5),
        Text(
          "26/01/2025",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white, 
        ),
        ),
      ]
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
              Text("Time: ", style: TextStyle(color: Colors.grey[700])),
              SizedBox(width: 5), 
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
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(time, style: TextStyle(fontSize: 16)),
    );
  }

  /// Duration Selector
  Widget _buildDurationSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Duration", style: TextStyle(fontSize: 16)), 
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), 
                  offset: Offset(4, 4),
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
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
              _buildCategoryChip("Academic", Colors.blue),
              SizedBox(width: 10),
              _buildCategoryChip("Social", Colors.green),
              SizedBox(width: 10),
              _buildCategoryChip("Health", Colors.red),
            ],
          ),
          SizedBox(height: 10), 
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryChip("Employment", Colors.orange),
              SizedBox(width: 10),
              _buildCategoryChip("Chore", Colors.purple),
              SizedBox(width: 10),
              _buildCategoryChip("Hobby", Colors.cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }

  /// Repeat Options
  Widget _buildRepeatOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Repeat", style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(4, 4),
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.teal[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(label, style: TextStyle(color: Colors.white)),
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
          border: OutlineInputBorder(),
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
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {}, // no backend logic yet
            child: Text("Save Task"),
          ),
        ],
      ),
    );
  }
}
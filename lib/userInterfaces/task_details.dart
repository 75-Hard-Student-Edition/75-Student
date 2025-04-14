import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_75/models/task_model.dart';

class TaskDetails extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onComplete;

  const TaskDetails({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Color taskColor = _getTaskColor(task.category);

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: taskColor, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title & Category
            Row(
              children: [
                Icon(_getCategoryIcon(task.category),
                    color: taskColor, size: 40),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.name,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: taskColor),
                    ),
                    _buildBadge(
                        task.category.toString().split('.').last, taskColor),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Date & Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("📅 ${DateFormat('dd/MM/yyyy').format(task.startTime)}",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.black54)),
                Text(
                    "⏰ ${DateFormat('HH:mm').format(task.startTime)} - ${DateFormat('HH:mm').format(task.endTime)}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),

            // Description
            if (task.description.isNotEmpty)
              _buildSection("📝 Notes", task.description),

            // Location if available
            if (task.location != null)
              _buildSection("📍 Location", task.location!.name),

            // Notifs
            if (task.notifyBefore.inMinutes > 0)
              _buildSection("🔔 Notify",
                  "Remind ${task.notifyBefore.inMinutes} minutes before"),

            const SizedBox(height: 15),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _actionButton(Icons.visibility_off, "Hide", taskColor),
                _actionButton(Icons.copy, "Copy", taskColor),
                GestureDetector(
                  onTap: onComplete,
                  child: _actionButton(Icons.check_circle,
                      task.isComplete ? "Undo" : "Complete", taskColor),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Edit Task Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: taskColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: onEdit,
                child: const Text("Edit Task",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text(content, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(6)),
      child: Text(text.toUpperCase(),
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: color)),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Color _getTaskColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.academic:
        return const Color(0xFF81E4F0);
      case TaskCategory.social:
        return const Color(0xFF8AD483);
      case TaskCategory.health:
        return const Color(0xFFFF4F4F);
      case TaskCategory.employment:
        return const Color(0xFFEDBF45);
      case TaskCategory.chore:
        return const Color(0xFFE997CD);
      case TaskCategory.hobby:
        return const Color(0xFF946AAE);
    }
  }

  IconData _getCategoryIcon(TaskCategory category) {
    switch (category) {
      case TaskCategory.academic:
        return Icons.school;
      case TaskCategory.social:
        return Icons.groups;
      case TaskCategory.health:
        return Icons.medication;
      case TaskCategory.employment:
        return Icons.attach_money;
      case TaskCategory.chore:
        return Icons.local_laundry_service;
      case TaskCategory.hobby:
        return Icons.sports_esports;
    }
  }
}

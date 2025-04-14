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
          color: const Color.fromARGB(255, 229, 242, 241),
          border: Border.all(color: Color(0xFF00B3A1), width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New Top Row Layout
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: Center(
                    child: Icon(_getCategoryIcon(task.category),
                        color: taskColor, size: 40),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              DateFormat('dd/MM/yyyy').format(task.startTime),
                              style: const TextStyle(
                                fontFamily: 'KdamThmorPro',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "${DateFormat('HH:mm').format(task.startTime)} - ${DateFormat('HH:mm').format(task.endTime)}",
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontFamily: 'KdamThmorPro',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task.name,
                        style: TextStyle(
                          fontFamily: 'KdamThmorPro',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: taskColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _buildBadge(task.category.toString().split('.').last, taskColor),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),

            // Container for Action Buttons
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0x8CFFFBFB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildSection("  📍 Location", task.location?.name ?? " "),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildSection("  📝 Notes", task.description),
                  ),
                  const SizedBox(height: 10),

                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildSection("  🔗 Links", task.links ?? " "),
                  ),
                  const Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _actionButton(Icons.delete, "Delete", taskColor),
                      _actionButton(Icons.copy, "Copy", taskColor),
                      GestureDetector(
                        onTap: onComplete,
                        child: _actionButton(Icons.check_circle,
                            task.isComplete ? "Undo" : "Complete", taskColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                          style: TextStyle(color: Colors.white, fontFamily: 'KdamThmorPro',)),
                    ),
                  ),
                ],
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
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'KdamThmorPro',),
        ),
        const SizedBox(height: 5),
        Text(content, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.6),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'KdamThmorPro',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: color, fontSize: 12, fontFamily: 'KdamThmorPro')),
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

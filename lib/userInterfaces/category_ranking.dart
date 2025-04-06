import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/home.dart';

class CategoryRankingScreen extends StatefulWidget {
  const CategoryRankingScreen({super.key});

  @override
  _CategoryRankingScreenState createState() => _CategoryRankingScreenState();
}

class _CategoryRankingScreenState extends State<CategoryRankingScreen> {
  List<Map<String, dynamic>> categories = [
    {"name": "Academic", "color": Colors.redAccent},
    {"name": "Social", "color": Colors.greenAccent},
    {"name": "Health", "color": Colors.blueAccent},
    {"name": "Career", "color": Colors.orangeAccent},
    {"name": "Mindfulness", "color": Colors.pinkAccent},
  ];

  List<Map<String, dynamic>?> droppedItems = List.filled(5, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9F2F2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Order your categories",
                    style: TextStyle(
                      fontFamily: 'kdamThmorPro',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 23, 212, 190),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "In the next 75 days, what are you trying to improve on the most?",
                    style: TextStyle(
                      fontFamily: 'kdamThmorPro',
                      fontSize: 11,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Drop Target Boxes
            for (int i = 0; i < 5; i++) buildDropTarget(i),

            const SizedBox(height: 20),

            // Draggable Buttons
            Wrap(
              spacing: 10,
              children: categories
                  .where((item) => !droppedItems.contains(item))
                  .map((item) => buildDraggable(item))
                  .toList(),
            ),

            const SizedBox(height: 30),

            // Next Button
            ElevatedButton(
              onPressed: () {
                //todo use the accountManager to save the order of categories
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 174, 145),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "NEXT",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'kdamThmorPro',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Draggable Category Buttons with Colors
  Widget buildDraggable(Map<String, dynamic> category) {
    return Draggable<Map<String, dynamic>>(
      data: category,
      feedback: Material(
        color: Colors.transparent,
        child: buildCategoryBox(category["name"], category["color"]),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: buildCategoryBox(category["name"], category["color"]),
      ),
      child: buildCategoryBox(category["name"], category["color"]),
    );
  }

  // Drop Target Boxes that Inherit Colors
  Widget buildDropTarget(int index) {
    return DragTarget<Map<String, dynamic>>(
      onAccept: (data) {
        setState(() {
          droppedItems[index] = data;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 50,
          width: 250,
          decoration: BoxDecoration(
            color: droppedItems[index] != null ? droppedItems[index]!["color"] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            //boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
          ),
          alignment: Alignment.center,
          child: Text(
            droppedItems[index]?["name"] ?? "",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  // Category Button with Dynamic Colors
  Widget buildCategoryBox(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'kdamThmorPro',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

//todo: change the colors to match formatting of homePage and addTask
//todo: change the categories to match the categories listed as enum in task_model (import)
//todo: allow for drag out of the box as well as drag in and keep formatting

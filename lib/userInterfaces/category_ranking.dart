import 'package:flutter/material.dart';
import 'package:student_75/userInterfaces/home.dart';
import 'package:student_75/models/task_model.dart';
import 'package:student_75/models/difficulty_enum.dart';
import 'package:student_75/userInterfaces/notifications.dart';

class CategoryRankingScreen extends StatefulWidget {
  final Difficulty difficulty;
  const CategoryRankingScreen({super.key, required this.difficulty});

  @override
  _CategoryRankingScreenState createState() => _CategoryRankingScreenState();
}

class _CategoryRankingScreenState extends State<CategoryRankingScreen> {
  List<Map<String, dynamic>> categories = [
    {
      "name": "Academic",
      "enum": TaskCategory.academic,
      "color": const Color(0xFF00BCD4)
    },
    {
      "name": "Social",
      "enum": TaskCategory.social,
      "color": const Color(0xFF8AD483)
    },
    {
      "name": "Health",
      "enum": TaskCategory.health,
      "color": const Color(0xFFF67373)
    },
    {
      "name": "Employment",
      "enum": TaskCategory.employment,
      "color": const Color(0xFFEDBF45)
    },
    {
      "name": "Chore",
      "enum": TaskCategory.chore,
      "color": const Color(0xFFE997CD)
    },
    {
      "name": "Hobby",
      "enum": TaskCategory.hobby,
      "color": const Color(0xFF946AAE)
    },
  ];

  List<Map<String, dynamic>?> droppedItems = List.filled(6, null);
  List<TaskCategory> rankedCategories = [];

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
              padding: const EdgeInsets.only(top: 36.0, left: 8.0, right: 8.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF00A59B), size: 30),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Center(
                    child: Text(
                      "Order your categories",
                      style: TextStyle(
                        fontFamily: 'kdamThmorPro',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF17D4BE),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "In the next 75 days, what are you trying to improve on the most?",
                    style: TextStyle(
                      fontFamily: 'kdamThmorPro',
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Drop Target Boxes
            const Text(
              'Most',
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'kdamThmorPro',
                color: Color(0xFF17D4BE),
              ),
            ),
            const SizedBox(height: 2),
            for (int i = 0; i < 6; i++) ...[
              buildDropTarget(i),
              if (i == 5)
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Least',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'kdamThmorPro',
                      color: Color(0xFF17D4BE),
                    ),
                  ),
                ),
            ],

            const SizedBox(height: 20),

            // Draggable Buttons
            Center(
              child: SizedBox(
                width: 160,
                height: 85,
                child: Stack(
                  children: categories
                      .where((item) => !droppedItems.contains(item))
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                    int i = entry.key;
                    var item = entry.value;
                    return Positioned(
                      left: i.toDouble() * 2,
                      top: i.toDouble() * 2,
                      child: buildDraggable(item),
                    );
                  }).toList(),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Next Button
            ElevatedButton(
              onPressed: () {
                rankedCategories = droppedItems
                  .where((item) => item != null)
                  .map((item) => item!["enum"])
                  .toList()
                  .cast<TaskCategory>();

              debugPrint("Saved rankedCategories: $rankedCategories");

              Map<TaskCategory, double> categoryRanks = {
                for (int i = 0; i < rankedCategories.length; i++) rankedCategories[i]: 3.0 - (i * 0.5)
              };

              TaskCategory topCategory = rankedCategories.isNotEmpty ? rankedCategories[0] : TaskCategory.academic;

              categoryRanks.forEach((category, rank) {
                debugPrint("$category value: $rank");
              });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(
                      difficulty: widget.difficulty,
                      topCategory: topCategory,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF11AE91),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "NEXT",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'kdamThmorPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
    return SizedBox(
      width: 150,
      height: 50,
      child: Draggable<Map<String, dynamic>>(
        data: category,
        feedback: Material(
          color: Colors.transparent,
          child: Center(
            child: buildCategoryBox(category["name"], category["color"]),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.5,
          child: Center(
            child: buildCategoryBox(category["name"], category["color"]),
          ),
        ),
        child: Center(
          child: buildCategoryBox(category["name"], category["color"]),
        ),
      ),
    );
  }

  // Drop Target Boxes that Inherit Colors
  Widget buildDropTarget(int index) {
    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (data) {
        setState(() {
          droppedItems[index] = data.data;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(vertical: 8),
          width: 350,
          height: 50,
          decoration: BoxDecoration(
            color: droppedItems[index] != null
                ? droppedItems[index]!["color"]
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Center(
            child: Text(
              droppedItems[index]?["name"] ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'kdamThmorPro',
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
        );
      },
    );
  }

  // Category Button with Dynamic Colors

  Widget buildCategoryBox(String text, Color color) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 50,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'kdamThmorPro',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

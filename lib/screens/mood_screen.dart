import 'package:flutter/material.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String? selectedMood;

  final List<Map<String, String>> moods = [
    {"emoji": "😊", "label": "Happy"},
    {"emoji": "😔", "label": "Sad"},
    {"emoji": "😡", "label": "Angry"},
    {"emoji": "😌", "label": "Calm"},
    {"emoji": "😰", "label": "Anxious"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How are you today?"),
        backgroundColor: Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: moods.map((mood) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = mood["label"];
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: selectedMood == mood["label"]
                          ? Color(0xFF6C63FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6)
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(mood["emoji"]!,
                            style: TextStyle(fontSize: 30)),
                        SizedBox(height: 5),
                        Text(
                          mood["label"]!,
                          style: TextStyle(
                            color: selectedMood == mood["label"]
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'meditation_duration_screen.dart';

class MeditationCategoryScreen extends StatelessWidget {
  const MeditationCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        "title": "Sleep Meditation",
        "desc": "Drift into deep restful sleep",
        "icon": Icons.nightlight_round,
        "duration": "5-15 min"
      },
      {
        "title": "Morning Gratitude",
        "desc": "Start your day positively",
        "icon": Icons.wb_sunny,
        "duration": "5-10 min"
      },
      {
        "title": "Anxiety Relief",
        "desc": "Calm racing thoughts",
        "icon": Icons.spa,
        "duration": "5-15 min"
      },
      {
        "title": "Body Scan",
        "desc": "Relax every muscle",
        "icon": Icons.self_improvement,
        "duration": "10-15 min"
      },
      {
        "title": "Mindfulness",
        "desc": "Stay present in the moment",
        "icon": Icons.psychology,
        "duration": "5-10 min"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Your Meditation"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final item = categories[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeditationDurationScreen(
                      category: item["title"].toString(),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFB39DDB)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(item["icon"] as IconData,
                        color: Colors.white, size: 30),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["title"].toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["desc"].toString(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Duration: ${item["duration"]}",
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';

class MeditationDurationScreen extends StatelessWidget {
  final String category;

  const MeditationDurationScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final durations = [5, 10, 15];

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text("Choose Duration",
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: durations.map((minutes) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MeditationSessionScreen(
                          category: category,
                          durationMinutes: minutes,
                        ),
                      ),
                    );
                  },
                  child: Text("$minutes min"),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'breathing_session_screen.dart';

class BreathingMethodScreen extends StatelessWidget {
  const BreathingMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Breathing Method"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            buildMethodCard(
              context,
              "Box Breathing (4-4-4-4)",
              "Great for focus & stress relief",
              4, 4, 4,
            ),

            buildMethodCard(
              context,
              "4-7-8 Relaxing Breath",
              "Helps with anxiety & sleep",
              4, 7, 8,
            ),

            buildMethodCard(
              context,
              "Deep Calm Breathing",
              "Slow breathing for relaxation",
              5, 5, 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMethodCard(
      BuildContext context,
      String title,
      String subtitle,
      int inhale,
      int hold,
      int exhale,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BreathingSessionScreen(
              inhale: inhale,
              hold: hold,
              exhale: exhale,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5)
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'relaxation_screen.dart';
import 'self_care_screen.dart';
import 'emergency_screen.dart';
import 'breathing_method_screen.dart';
import 'meditation_category_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String userName = "Beautiful Soul 💜";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF6C63FF),
                Color(0xFFB39DDB),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Greeting
                Text(
                  "Hello, $userName",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Take a deep breath. You're safe here.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                /// Motivation Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: const [
                      Text(
                        "🌟 Today's Motivation",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "You survived 100% of your hardest days. Keep going 💜",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// Relax Section
                const Text(
                  "Relax & Unwind",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                buildRelaxCard(context, Icons.self_improvement, "Guided Breathing"),
                buildRelaxCard(context, Icons.music_note, "Calm Music"),
                buildRelaxCard(context, Icons.spa, "Meditation Session"),

                const SizedBox(height: 35),

                /// More Support Section
                const Text(
                  "More Support",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 15),

                buildRelaxCard(context, Icons.psychology, "Self-care Tips"),
                buildRelaxCard(context, Icons.volunteer_activism, "Emergency Help"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRelaxCard(
      BuildContext context, IconData icon, String title) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {

        if (title == "Guided Breathing") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BreathingMethodScreen(),
            ),
          );
        }

        else if (title == "Calm Music") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const RelaxationScreen(type: "music"),
            ),
          );
        }

        else if (title == "Meditation Session") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
              const MeditationCategoryScreen(),
            ),
          );
        }

        else if (title == "Self-care Tips") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelfCareScreen(),
            ),
          );
        }

        else if (title == "Emergency Help") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmergencyScreen(),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF6C63FF)),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeditationHistoryScreen extends StatefulWidget {
  const MeditationHistoryScreen({super.key});

  @override
  State<MeditationHistoryScreen> createState() =>
      _MeditationHistoryScreenState();
}

class _MeditationHistoryScreenState
    extends State<MeditationHistoryScreen> {
  List<String> history = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList("meditation_history") ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meditation History"),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: history.length,
        itemBuilder: (_, index) {
          return Card(
            child: ListTile(
              title: Text(history[index]),
            ),
          );
        },
      ),
    );
  }
}
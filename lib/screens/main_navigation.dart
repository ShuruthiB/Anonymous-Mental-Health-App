import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'mood_screen.dart';
import 'journal_screen.dart';
import 'community_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {

  int currentIndex = 0;

  final List<Widget> screens = [
    DashboardScreen(),
    MoodScreen(),
    JournalScreen(),
    CommunityScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood),
            label: "Mood",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: "Journal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.spa),
            label: "Community",
          ),
        ],
      ),
    );
  }
}
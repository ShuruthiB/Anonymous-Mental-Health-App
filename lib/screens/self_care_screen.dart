import 'package:flutter/material.dart';

class SelfCareScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self-care Tips"),
        backgroundColor: Color(0xFF6C63FF),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          tipCard("🌿 Take 5 deep breaths"),
          tipCard("💧 Drink enough water"),
          tipCard("📱 Take a short digital detox"),
          tipCard("🚶 Go for a 10-minute walk"),
          tipCard("📝 Write your feelings in a journal"),
        ],
      ),
    );
  }

  Widget tipCard(String text) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
        ],
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
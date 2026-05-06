import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreen extends StatelessWidget {

  Future<void> callNumber(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emergency Help"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            emergencyCard("📞 Call 112 (India Emergency)", "112"),
            emergencyCard("🧠 Mental Health Helpline", "18005990019"),
          ],
        ),
      ),
    );
  }

  Widget emergencyCard(String title, String number) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () => callNumber(number),
        child: Container(
          margin: EdgeInsets.only(bottom: 20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Icon(Icons.call, color: Colors.red),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
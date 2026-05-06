import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class JournalScreen extends StatefulWidget {
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _controller = TextEditingController();
  bool isLoading = false;

  Future<void> saveJournal() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Journal cannot be empty")),
      );
      return;
    }

    setState(() => isLoading = true);

    await _service.addJournal(_controller.text.trim());

    setState(() => isLoading = false);

    _controller.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Journal saved 💙")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Private Journal")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Write your thoughts...",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: saveJournal,
                    child: Text("Save"),
                  ),
          ],
        ),
      ),
    );
  }
}
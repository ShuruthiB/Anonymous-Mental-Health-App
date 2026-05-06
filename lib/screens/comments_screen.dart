import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // ✅ Add Comment
  Future<void> addComment() async {
    if (!isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login to comment 💬")),
      );
      return;
    }

    if (_commentController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('community_posts')
        .doc(widget.postId)
        .collection('comments')
        .add({
      'text': _commentController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Comments")),

      body: Column(
        children: [
          // 📜 Comments List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('community_posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No comments yet 💬"));
                }

                var comments = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    var data =
                        comments[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        title: Text(data['text'] ?? ""),
                        subtitle: const Text("Anonymous User"),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ✍️ Comment Input Box (FIXED UI)
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: isLoggedIn
                  ? Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            minLines: 1,
                            maxLines: 4, // ✅ Expands
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: "Write a comment...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: addComment,
                        )
                      ],
                    )
                  : const Text(
                      "Login to comment 💬",
                      style: TextStyle(color: Colors.grey),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:anonymous_mental_health_app/screens/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // 🔥 Add Post
  void addPost() async {
    if (!isLoggedIn) return;

    if (_postController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('community_posts').add({
      'content': _postController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'likes': 0,
      'likedBy': [],
      'isAnonymous': true,
    });

    _postController.clear();
  }

  // ❤️ Like Post
  void likePost(String postId, List likedBy) async {
    if (!isLoggedIn) return;

    String userId = FirebaseAuth.instance.currentUser!.uid;

    if (likedBy.contains(userId)) {
      // ❌ Already liked → remove like (toggle)
      await FirebaseFirestore.instance
          .collection('community_posts')
          .doc(postId)
          .update({
            'likes': FieldValue.increment(-1),
            'likedBy': FieldValue.arrayRemove([userId]),
          });
    } else {
      // ✅ First time like
      await FirebaseFirestore.instance
          .collection('community_posts')
          .doc(postId)
          .update({
            'likes': FieldValue.increment(1),
            'likedBy': FieldValue.arrayUnion([userId]),
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Community Support 💙")),

      body: Column(
        children: [
          // ✍️ Post Box
          if (isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _postController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Share your experience anonymously...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(icon: Icon(Icons.send), onPressed: addPost),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Login to share, like and comment 💙",
                style: TextStyle(color: Colors.grey),
              ),
            ),

          // 📜 Posts List
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('community_posts')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var posts = snapshot.data.docs;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    var post = posts[index];
                    var data = post.data() as Map<String, dynamic>;

                    List likedBy = data['likedBy'] ?? [];
                    int likes = data['likes'] ?? 0;

                    bool isLiked = likedBy.contains(
                      FirebaseAuth.instance.currentUser?.uid,
                    );

                    return Card(
                      child: Column(
                        children: [
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc(data['userId'])
                                .get(),
                            builder: (context, snapshot) {
                              String username = "Anonymous"; // default

                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Anonymous", style: TextStyle(fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text(data['content'] ?? ""),
                                  ],
                                );
                              }

                              if (snapshot.hasData && snapshot.data!.exists) {
                                var userData = snapshot.data!.data() as Map<String, dynamic>;
                                username = userData['username'] ?? "Anonymous";
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Text(data['content'] ?? ""),
                                ],
                              );
                            },
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: isLiked ? Colors.red : Colors.grey,
                                ),
                                onPressed: isLoggedIn
                                    ? () => likePost(post.id, likedBy)
                                    : null,
                              ),
                              Text(likes.toString()),

                              SizedBox(width: 20),

                              IconButton(
                                icon: Icon(Icons.comment),
                                onPressed: isLoggedIn
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                CommentsScreen(postId: post.id),
                                          ),
                                        );
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

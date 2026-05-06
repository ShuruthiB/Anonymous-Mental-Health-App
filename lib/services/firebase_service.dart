import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInAnonymously() async {
    UserCredential userCredential =
        await _auth.signInAnonymously();
    return userCredential.user;
  }

  Future<void> saveMood(String mood) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('moods').add({
      'uid': uid,
      'mood': mood,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> addJournal(String text) async {
    String uid = _auth.currentUser!.uid;
    await _firestore.collection('journals').add({
      'uid': uid,
      'text': text,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> addPost(String message) async {
    await _firestore.collection('posts').add({
      'message': message,
      'timestamp': Timestamp.now(),
      'likes': 0,
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
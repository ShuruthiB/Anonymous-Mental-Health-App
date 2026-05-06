import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  // 🔥 Generate Anonymous Username
  String generateUsername() {
    final random = Random();
    int number = random.nextInt(9000) + 1000;
    return "User_$number";
  }

  Future<void> signUp() async {
    setState(() => isLoading = true);

    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCred.user!.uid;

      // 🔥 Store anonymous profile
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': generateUsername(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context); // go to login

    } catch (e) {
      print(e);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),

            SizedBox(height: 20),

            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: signUp,
                    child: Text("Create Account"),
                  ),
          ],
        ),
      ),
    );
  }
}
import 'dart:developer';
import 'package:five/screens/forum/post.list.screen.dart';
import 'package:five/screens/chatbot/chatbot.screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seminar Five'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String emailAddress =
                    "test-${DateTime.now().millisecondsSinceEpoch.toString()}@gmail.com";
                String password = "12345a,*";

                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailAddress,
                    password: password,
                  );
                  log("--> user created with uid: ${credential.user?.uid}");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    debugPrint('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    debugPrint('The account already exists for that email.');
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('Create a user'),
            ),
            TextField(
              controller: email,
              decoration: const InputDecoration(hintText: 'Email'),
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final registered = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text,
                    password: password.text,
                  );
                  log("--> user registered with uid: ${registered.user?.uid}");
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'email-already-in-use') {
                    try {
                      final signedIn = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email.text,
                        password: password.text,
                      );
                      log("--> user signed in with uid: ${signedIn.user?.uid}");
                    } catch (e) {
                      log('---> Signed error: $e');
                    }
                  } else {
                    log('---> FirebaseAuthException: $e');
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
              child: const Text('Register or Sign-in'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ForumListScreen()),
                );
              },
              child: const Text('Open Forum'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChatBotScreen()),
                );
              },
              child: const Text('Open ChatBot'),
            ),
          ],
        ),
      ),
    );
  }
}

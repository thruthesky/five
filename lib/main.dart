import 'dart:developer';

import 'package:five/firebase_options.dart';
import 'package:five/screens/home.screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FiveApp());
}

class FiveApp extends StatefulWidget {
  const FiveApp({Key? key}) : super(key: key);

  @override
  State<FiveApp> createState() => _FiveAppState();
}

class _FiveAppState extends State<FiveApp> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('--> User is currently signed out!');
      } else {
        log('--> User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

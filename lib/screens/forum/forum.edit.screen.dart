import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ForumEditScreen extends StatefulWidget {
  const ForumEditScreen({Key? key}) : super(key: key);

  @override
  State<ForumEditScreen> createState() => _ForumEditScreenState();
}

class _ForumEditScreenState extends State<ForumEditScreen> {
  final title = TextEditingController();
  final content = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forum List')),
      body: Column(
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(hintText: 'Input title'),
          ),
          TextField(
            controller: content,
            decoration: const InputDecoration(hintText: 'Input content'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final docRef = ref.child('forum').push();
                // print('key; ${docRef.key}');
                await docRef.set({
                  "title": title.text,
                  "content": content.text,
                  "createdAt": ServerValue.timestamp,
                  "updatedAt": ServerValue.timestamp,
                });
                log('--> success: post has created');
                if (!mounted) return;
                Navigator.pop(context);
              } catch (e) {
                log('--> failure: forum create error; $e');
              }
            },
            child: const Text('Create a post'),
          ),
        ],
      ),
    );
  }
}

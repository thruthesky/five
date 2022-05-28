import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatbotDataScreen extends StatefulWidget {
  const ChatbotDataScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotDataScreen> createState() => _ChatbotDataScreenState();
}

class _ChatbotDataScreenState extends State<ChatbotDataScreen> {
  final title = TextEditingController();
  final content = TextEditingController();
  final search1 = TextEditingController();
  final search2 = TextEditingController();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChatBot Data')),
      body: Column(
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(hintText: 'Input title'),
          ),
          TextFormField(
            controller: content,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              filled: true,
              hintText: 'Enter a description...',
              labelText: 'Description',
            ),
            /*
                          onChanged: (value) {
                            description = value;
                          },
                          */
            maxLines: 5,
          ),
          /*        
          TextField(
            controller: content,
            decoration: const InputDecoration(hintText: 'Input content'),
          ),
          */
          TextField(
            controller: search1,
            decoration: const InputDecoration(hintText: 'Input search'),
          ),
          TextField(
            controller: search2,
            decoration: const InputDecoration(hintText: 'Input search'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final data = <String, dynamic>{
                  "title": title.text,
                  "content": content.text,
                  "search1": search1.text,
                  "search2": search2.text,
                };
                db.collection('chatbot').add(data).then((DocumentReference
                        doc) =>
                    debugPrint('DocumentSnapshot added with ID: ${doc.id}'));
                log('--> success: post has created');
                if (!mounted) return;
                // Navigator.pop(context);
              } catch (e) {
                log('--> failure: forum create error; $e');
              }
            },
            child: const Text('Create a data'),
          ),
        ],
      ),
    );
  }
}

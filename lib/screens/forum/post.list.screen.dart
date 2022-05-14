import 'package:firebase_database/firebase_database.dart';
import 'package:five/screens/forum/forum.edit.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/database.dart';

class ForumListScreen extends StatefulWidget {
  const ForumListScreen({Key? key}) : super(key: key);

  @override
  State<ForumListScreen> createState() => _ForumListScreenState();
}

class _ForumListScreenState extends State<ForumListScreen> {
  final title = TextEditingController();
  final content = TextEditingController();

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    final usersQuery = FirebaseDatabase.instance.ref('forum').orderByChild('createdAt');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum List'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ForumEditScreen()),
              );
            },
            icon: const Icon(
              Icons.create,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: FirebaseDatabaseListView(
        pageSize: 10,
        query: usersQuery,
        itemBuilder: (context, snapshot) {
          dynamic post = snapshot.value;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${post['title']}',
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text('${post['content']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

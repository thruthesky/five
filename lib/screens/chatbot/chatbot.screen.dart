// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:five/screens/chatbot/chatbot.data.screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/database.dart';

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final sendMsg = TextEditingController();
  String searchStr = 'Hello.';
  late Future<String> chatbotGetData;
  List<ChatMessage> messages = [];
  bool dataFind = false;

  //String chatbotStr = '';

  FirebaseFirestore db = FirebaseFirestore.instance;

  // FirebaseFirestore.collection citiesRef = db.collection("chatbot");
  // db.collection('chatbot').whereArrayContains('content', 'Hello');
  // var messages = List.empty(growable: true);
  /*
  Future<String> _chatbotGetData() async {
    List<Future<QuerySnapshot>> futures = [];

    var firstQuery =
        db.collection('chatbot').where('search1', isEqualTo: searchStr).get();

    var secondQuery =
        db.collection('chatbot').where('search2', isEqualTo: searchStr).get();

    futures.add(firstQuery);
    futures.add(secondQuery);

    List<QuerySnapshot> results = await Future.wait(futures);
    for (var res in results) {
      // debugPrint('====================>${res.docs[0].data()['content']}');
      for (var docResults in res.docs) {
        // ignore: prefer_interpolation_to_compose_strings
        debugPrint('====================>' + docResults.data()['content']);
      }
    }
    return '';
  }
  */

  Future<String> _chatbotGetData() async {
    return await db
        .collection('chatbot')
        .orderBy('search1')
        .startAt([searchStr])
        .endAt(['$searchStr\uf8ff'])
        /*
        .where(
          'title',
          isGreaterThanOrEqualTo: searchStr,
          isLessThan: searchStr.substring(0, searchStr.length - 1) +
              String.fromCharCode(
                  searchStr.codeUnitAt(searchStr.length - 1) + 1),
        )
        */
        //.orderBy('title')
        //.startAfter([searchStr])
        //.endAt(['$searchStr\uf8ff'])
        .get()
        .then((event) {
          //           .where("title", isEqualTo: searchStr).get()
          debugPrint(event.docs.length.toString());
          debugPrint('**********$event.docs.toString()');
          // chatbotStr = '';
          // ignore: prefer_is_empty
          if (event.docs.length > 1) {
            dataFind = true;
            messages.add(ChatMessage(
                messageContent: '다음 항목에서 선택하세요.', messageType: "receiver"));
          }
          for (var doc in event.docs) {
            debugPrint("---> $searchStr");
            debugPrint("====> ${doc.id} => ${doc.data()}");
            if (event.docs.length == 1) {
              dataFind = true;
              messages.add(ChatMessage(
                  messageContent: doc.data()['content'].toString(),
                  messageType: "receiver"));
              // chatbotStr = doc.data()['content'].toString();
              // return 0;
              // doc.data()['content'].toString();
            } else if (event.docs.length > 1) {
              messages.add(ChatMessage(
                  messageContent: doc.data()['title'].toString(),
                  messageType: "receiver-menu"));
            }
          }
          return '';
        });
  }

  Future<String> _chatbotGetData2() async {
    return await db
        .collection('chatbot')
        .where('title', isEqualTo: searchStr)
        .get()
        .then((event) {
      for (var doc in event.docs) {
        if (event.docs.length == 1) {
          dataFind = true;
          messages.add(ChatMessage(
              messageContent: doc.data()['content'].toString(),
              messageType: "receiver"));
          // chatbotStr = doc.data()['content'].toString();
          // return 0;
          // doc.data()['content'].toString();
        } else if (event.docs.length > 1) {
          messages.add(ChatMessage(
              messageContent: doc.data()['title'].toString(),
              messageType: "receiver-menu"));
        }
      }
      return '';
    });
  }

  @override
  void initState() {
    super.initState();
    // _chatbotGetData();
    chatbotGetData = _chatbotGetData();
  }

  @override
  Widget build(BuildContext context) {
    /*
    final usersQuery =
        FirebaseDatabase.instance.ref('chatbot').orderByChild('createdAt');
    */
    // ignore: unused_local_variable
    // _chatbotGetData('Hello.');
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatBot'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChatbotDataScreen()),
              );
            },
            icon: const Icon(
              Icons.create,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: FutureBuilder<String>(
                future: chatbotGetData,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData == false) {
                    return Container(
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                            alignment: (messages[index].messageType == "sender"
                                ? Alignment.topRight
                                : Alignment.topLeft),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    (messages[index].messageType == "receiver"
                                        ? Colors.grey.shade200
                                        : messages[index].messageType ==
                                                "receiver-menu"
                                            ? Color.fromARGB(255, 238, 223, 142)
                                            : Colors.blue[200]),
                              ),
                              padding: const EdgeInsets.all(16),
                              child: (messages[index].messageType ==
                                      "receiver-menu")
                                  ? InkWell(
                                      onTap: () async {
                                        sendMsg.text =
                                            messages[index].messageContent;
                                        dataFind = false;
                                        messages.add(ChatMessage(
                                            messageContent: sendMsg.text,
                                            messageType: "sender"));
                                        searchStr = sendMsg.text;
                                        await _chatbotGetData2();
                                        if (dataFind == false) {
                                          messages.add(ChatMessage(
                                              messageContent:
                                                  '질문에 해당하는 답변이 준비되지 않았습니다.\n 다른 검색어를 입력해 주세요.',
                                              messageType: "receiver"));
                                        }
                                        setState(() {});
                                        sendMsg.text = '';
                                      },
                                      child: Text(
                                        messages[index].messageContent,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    )
                                  : Text(
                                      messages[index].messageContent,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: sendMsg,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      dataFind = false;
                      if (sendMsg.text != '') {
                        messages.add(ChatMessage(
                            messageContent: sendMsg.text,
                            messageType: "sender"));
                        searchStr = sendMsg.text;
                        await _chatbotGetData();
                        if (dataFind == false) {
                          messages.add(ChatMessage(
                              messageContent:
                                  '질문에 해당하는 답변이 준비되지 않았습니다.\n 다른 검색어를 입력해 주세요.',
                              messageType: "receiver"));
                        }
                        setState(() {});
                        sendMsg.text = '';
                      }
                    },
                    // ignore: sort_child_properties_last
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.blue,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

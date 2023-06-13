import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_chat_page.dart';


class ChatList extends StatefulWidget {
  const ChatList({Key? key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  List<String> _userIDs = [];
  List<String> _userNames = [];

  @override
  void initState() {
    super.initState();
    fetchUserIDs();
  }

  Future<void> fetchUserIDs() async {
    final snapshot = await _chatsCollection.get();
    final chatDocs = snapshot.docs;

    for (final chatDoc in chatDocs) {
      final userID = chatDoc.get('userID');
      final userSnapshot = await _usersCollection.doc(userID).get();

      if (userSnapshot.exists) {
        final userName = userSnapshot.get('name');
        setState(() {
          _userIDs.add(userID);
          _userNames.add(userName);
        });
      }
    }
  }

  void navigateToAdminResponse(int index) {
    final userID = _userIDs[index];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AdminResponse(chatDocName: userID)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat List"),
      ),
      body: ListView.builder(
        itemCount: _userNames.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text("You Have Messages From ${_userNames[index]}", style: TextStyle(fontSize: 19)),
              onTap: () {
                navigateToAdminResponse(index);
              },
            ),
          );
        },
      ),
    );
  }
}
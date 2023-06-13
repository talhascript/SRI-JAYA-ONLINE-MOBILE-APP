import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerChat extends StatefulWidget {
  const CustomerChat({Key? key});

  @override
  State<CustomerChat> createState() => _CustomerChatState();
}

class _CustomerChatState extends State<CustomerChat> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference _chatsCollection = FirebaseFirestore.instance.collection('chats');
  late Stream<DocumentSnapshot> _chatStream;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      final userID = user.uid;
      _chatStream = _chatsCollection.doc(userID).snapshots();
    }
  }

  void sendMessage(String message) async {
    final user = _auth.currentUser;
    if (user != null) {
      final userID = user.uid;
      final chatRef = _chatsCollection.doc(userID);
      final chatDoc = await chatRef.get();
      if (chatDoc.exists) {
        final currentMessages = List<String>.from((chatDoc.data() as Map<String, dynamic>)['messages'] ?? []);
        currentMessages.add(message);
        await chatRef.update({'messages': currentMessages});
      } else {
        await chatRef.set({'userID': userID, 'messages': [message], 'replies': []});
      }
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat With Us"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _chatStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chatData = (snapshot.data!.data() as Map<String, dynamic>?) ?? {};
                  final userID = chatData['userID'];
                  final messages = List<String>.from(chatData['messages'] ?? []);
                  final replies = List<String>.from(chatData['replies'] ?? []);
                  final isCurrentUser = (_auth.currentUser?.uid == userID);

                  return ListView.builder(
                    itemCount: messages.length + replies.length,
                    itemBuilder: (context, index) {
                      if (index < messages.length) {
                        // Render customer messages
                        return ListTile(
                          leading: isCurrentUser ? Icon(Icons.account_circle,size: 30,) : null,
                          title: Text(messages[index],style: TextStyle(fontSize: 20),),
                        );
                      } else {
                        // Render admin replies
                        final replyIndex = index - messages.length;
                        return ListTile(
                          leading: Icon(Icons.brightness_auto_rounded, size: 30,),
                          title: Text(replies[replyIndex],style: TextStyle(fontSize: 20),),
                        );
                      }
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
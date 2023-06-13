import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminResponse extends StatefulWidget {
  final String chatDocName;

  const AdminResponse({required this.chatDocName});

  @override
  _AdminResponseState createState() => _AdminResponseState();
}

class _AdminResponseState extends State<AdminResponse> {
  final CollectionReference _chatsCollection =
      FirebaseFirestore.instance.collection('chats');
  final TextEditingController _messageController = TextEditingController();

  List<String> _messages = [];
  List<String> _replies = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final chatDoc = await _chatsCollection.doc(widget.chatDocName).get();

    if (chatDoc.exists) {
      final messages = List<String>.from(chatDoc.get('messages') ?? []);
      final replies = List<String>.from(chatDoc.get('replies') ?? []);
      setState(() {
        _messages = messages;
        _replies = replies;
      });
    }
  }

  void sendMessage(String message) async {
    final chatRef = _chatsCollection.doc(widget.chatDocName);
    final chatDoc = await chatRef.get();

    if (chatDoc.exists) {
      final currentReplies = List<String>.from(chatDoc.get('replies') ?? []);
      currentReplies.add(message);
      await chatRef.update({'replies': currentReplies});
    } else {
      await chatRef.set({'replies': [message]});
    }

    setState(() {
      _replies = List.from(_replies)..add(message);
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Response"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length + _replies.length,
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return ListTile(
                    leading: Icon(Icons.account_circle, size: 30),
                    title: Text(_messages[index]),
                  );
                } else {
                  final replyIndex = index - _messages.length;
                  return ListTile(
                    leading: Icon(Icons.brightness_auto_rounded, size: 30),
                    title: Text(_replies[replyIndex]),
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
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        sendMessage(value);
                      }
                    },
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
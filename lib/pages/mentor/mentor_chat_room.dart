import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:untitled1/components/chat_bubble.dart';
import 'package:untitled1/models/chat_service.dart';

class ChatRoom extends StatefulWidget {
  final String username;
  final String image;
  final String receiverId;

  const ChatRoom({
    super.key,
    required this.username,
    required this.image,
    required this.receiverId,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_message.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverId, _message.text);
      _message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        ],
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              child: RandomAvatar(widget.image, width: 100, height: 100),
            ),
            SizedBox(width: 10),
            Text(
              widget.username,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection("userinfo").doc(userId).get(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          if (!snapshots.hasData || !snapshots.data!.exists) {
            return Center(child: Text("No data found", style: TextStyle(color: Colors.white)));
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _buildMessageList()),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildMessageInput(),
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _message,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Enter Message",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: Icon(Icons.arrow_circle_right, size: 40),
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    bool isSender = data["senderId"] == FirebaseAuth.instance.currentUser!.uid;
    var align = isSender ? Alignment.centerRight : Alignment.centerLeft;

    Widget content;

    if (data["type"] == "milestone_review") {
      final goals = data["goals"] as Map<String, dynamic>? ?? {};

      content = Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: isSender ? Colors.green.shade100 : Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: goals.entries.map((e) {
            return Text(
              "${e.key}: ${e.value}",
              style: TextStyle(color: Colors.black, fontSize: 14),
            );
          }).toList(),
        ),
      );
    } else {
      // Fallback to regular message
      content = ChatBubble(message: data["message"] ?? '');
    }

    return Container(
      alignment: align,
      child: content,
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.blue));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text(
                "No messages yet",
                style: TextStyle(color: Colors.white),
              ));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }
}

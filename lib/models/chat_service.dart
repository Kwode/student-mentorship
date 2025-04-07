import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/models/message.dart';

class ChatService extends ChangeNotifier{
  //get instances
  final FirebaseAuth _firebase = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send message
  Future<void>sendMessage(String receiverId, String message)async {
    //getting user information
    final String currentUserId = _firebase.currentUser!.uid;
    final String currentUserEmail = _firebase.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //creating new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp
    );

    //sorting
    List<String> id = [currentUserId, receiverId];
    id.sort();
    String chatroomid = id.join("_");

    //add new message to firestore
    await _firestore.collection("chatroom")
        .doc(chatroomid)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get message
Stream<QuerySnapshot> getMessages (String userId, String otherUserId){
  List<String> id = [userId, otherUserId];
  id.sort();
  String chatroomid = id.join("_");

  return _firestore.collection("chatroom")
      .doc(chatroomid)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
}
}
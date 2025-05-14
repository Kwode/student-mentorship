import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Utility method to get a consistent chatId
  String getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return "${sorted[0]}_${sorted[1]}";
  }

  // Send a standard text message
  Future<void> sendMessage(String receiverId, String message) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("Error: No current user found!");
      return;
    }

    final chatId = getChatId(currentUser.uid, receiverId);

    try {
      await _firestore.collection('messages').add({
        'chatId': chatId,
        'senderId': currentUser.uid,
        'receiverId': receiverId,
        'timestamp': Timestamp.now(),
        'type': 'text',
        'message': message,
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Send structured milestone message
  Future<void> sendGoalsMessage(String receiverId, Map<String, dynamic> goals) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      print("Error: No current user found!");
      return;
    }

    final chatId = getChatId(currentUser.uid, receiverId);

    // Convert all goal values to strings to ensure null-safety
    final sanitizedGoals = goals.map((key, value) =>
        MapEntry(key, value?.toString() ?? ''));

    try {
      await _firestore.collection('messages').add({
        'chatId': chatId,
        'senderId': currentUser.uid,
        'receiverId': receiverId,
        'timestamp': Timestamp.now(),
        'type': 'milestone_review',
        'message': '', // placeholder to maintain message structure
        'goals': sanitizedGoals,
      });
    } catch (e) {
      print("Error sending goals message: $e");
    }
  }

  // Get chat messages by chatId
  Stream<QuerySnapshot> getMessages(String uid1, String uid2) {
    final chatId = getChatId(uid1, uid2);

    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MatchSystem {

  static Future<List<Map<String, dynamic>>> getInterestBasedMatches() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return [];

    final currentDoc = await FirebaseFirestore.instance
        .collection("userinfo")
        .doc(currentUser.uid)
        .get();

    if (!currentDoc.exists) return [];

    final currentPrefs = (currentDoc['preferences'] != null)
        ? List<String>.from(currentDoc['preferences'])
        : [];
  

    final querySnapshot = await FirebaseFirestore.instance.collection("userinfo").get();

    List<Map<String, dynamic>> matches = [];

    for (var doc in querySnapshot.docs) {
      if (doc.id == currentUser.uid) continue;

      final otherPrefs = (doc['preferences'] != null)
          ? List<String>.from(doc['preferences'])
          : [];

      final shared = currentPrefs.toSet().intersection(otherPrefs.toSet());
      if (shared.isEmpty) continue;

      matches.add({
        'uid': doc.id,
        'name': doc['name'] ?? 'Unknown',
        'sharedInterests': shared.toList(),
        'category': doc['category']
      });
    }

    matches.sort((a, b) =>
        b['sharedInterests'].length.compareTo(a['sharedInterests'].length));

    return matches;
  }

}


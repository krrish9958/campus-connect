import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> uploadNote({
    required String title,
    required String description,
    required String fileUrl,
  }) async {
    await _db.collection('notes').add({
      'title': title,
      'description': description,
      'fileUrl': fileUrl,
      'teacherId': _auth.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}

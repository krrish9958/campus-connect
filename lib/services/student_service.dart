import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';

class StudentService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<StudentModel> getOrCreateStudent() async {
    final user = _auth.currentUser!;
    final docRef = _db.collection('students').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final student = StudentModel(
        uid: user.uid,
        name: 'New Student',
        rollNo: 'Not Assigned',
        branch: 'CSE',
        year: 1,
        email: user.email!,
        role: 'student',
      );

      await docRef.set(student.toMap());
      return student;
    }

    return StudentModel.fromMap(doc.data()!, doc.id);
  }
}

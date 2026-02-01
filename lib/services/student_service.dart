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
        rollNo: '000000',
        branch: 'CSE',
        year: 1,
        email: user.email!,
      );

      await docRef.set(student.toMap());
      return student;
    }

    return StudentModel.fromMap(doc.data()!, doc.id);
  }

  // 🔥 UPDATE STUDENT PROFILE
  Future<void> updateStudent({
    required String name,
    required String rollNo,
    required String branch,
    required int year,
  }) async {
    final user = _auth.currentUser!;
    final docRef = _db.collection('students').doc(user.uid);

    await docRef.update({
      'name': name,
      'rollNo': rollNo,
      'branch': branch,
      'year': year,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // 🔥 FETCH ALL STUDENTS (for Teacher/Admin)
  Future<List<StudentModel>> getAllStudents() async {
    final snapshot = await _db.collection('students').get();

    return snapshot.docs
        .map((doc) => StudentModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  // 🔍 FETCH SINGLE STUDENT (for Teacher/Admin)
  Future<StudentModel?> getStudentById(String uid) async {
    final doc = await _db.collection('students').doc(uid).get();

    if (!doc.exists) return null;

    return StudentModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> assignTeacher({
    required String studentId,
    required String teacherId,
  }) async {
    await FirebaseFirestore.instance
        .collection('students')
        .doc(studentId)
        .update({'assignedTeacherId': teacherId});
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> markAttendance({
    required String studentId,
    required bool present,
    required DateTime date,
  }) async {
    final teacherId = _auth.currentUser!.uid;
    final dateKey = date.toIso8601String().split('T')[0];

    await _db
        .collection('attendance')
        .doc(teacherId)
        .collection(dateKey)
        .doc(studentId)
        .set({'present': present, 'timestamp': FieldValue.serverTimestamp()});
  }
}

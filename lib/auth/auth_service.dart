import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔐 LOGIN
  Future<User?> login({required String email, required String password}) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  // 🆕 SIGN UP + AUTO CREATE ROLE + STUDENT PROFILE
  Future<User?> signup({
    required String email,
    required String password,
  }) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user == null) return null;

    final uid = user.uid;

    // 🔥 Create users/{uid}
    await _db.collection('users').doc(uid).set({
      'role': 'student', // default role
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // 🔥 Create students/{uid}
    await _db.collection('students').doc(uid).set({
      'uid': uid,
      'name': 'New Student',
      'rollNo': 'Not Assigned',
      'branch': 'CSE',
      'year': 1,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }
}

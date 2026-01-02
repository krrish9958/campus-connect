import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';
import 'login_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        context.read<StudentProvider>().loadStudent();
      }
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const LoginScreen();
    }

    return Consumer<StudentProvider>(
      builder: (context, studentProvider, _) {
        if (studentProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final role = studentProvider.student?.role;

        if (role == 'student') {
          return const StudentDashboard();
        } else if (role == 'teacher') {
          return const TeacherDashboard();
        } else if (role == 'admin') {
          return const AdminDashboard();
        } else {
          return const Scaffold(body: Center(child: Text("Unknown role")));
        }
      },
    );
  }
}

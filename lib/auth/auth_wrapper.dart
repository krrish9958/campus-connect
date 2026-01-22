import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/user_role_service.dart';
import '../student/student_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../admin/admin_dashboard.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  AuthWrapper({super.key});

  final UserRoleService _roleService = UserRoleService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        // 🔥 User logged in → fetch role
        return FutureBuilder<String?>(
          future: _roleService.getUserRole(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;

            switch (role) {
              case 'student':
                return const StudentDashboard();
              case 'teacher':
                return const TeacherDashboard();
              case 'admin':
                return const AdminDashboard();
              default:
                return const Scaffold(
                  body: Center(child: Text('Unknown role')),
                );
            }
          },
        );
      },
    );
  }
}

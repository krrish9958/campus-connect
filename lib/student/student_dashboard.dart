import 'package:campus_connect/student/edit_student_profile_screen.dart';
import 'package:campus_connect/student/view_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../providers/student_provider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();

    // ✅ Load student ONCE safely
    Future.microtask(() {
      context.read<StudentProvider>().loadStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();
    final student = provider.student;

    if (provider.isLoading || student == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget _infoRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
              } else if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditStudentProfileScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PROFILE CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Name", student.name),
                    _infoRow("Roll No", student.rollNo),
                    _infoRow("Branch", student.branch),
                    _infoRow("Year", student.year.toString()),
                    _infoRow("Email", student.email),
                  ],
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text("View Notes"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ViewNotesScreen()),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // EDIT PROFILE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EditStudentProfileScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

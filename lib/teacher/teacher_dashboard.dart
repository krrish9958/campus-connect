import 'package:campus_connect/teacher/attendance_history_screen.dart';
import 'package:campus_connect/teacher/mark_attendance_screen.dart';
import 'package:campus_connect/teacher/upload_notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_list_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'logout') {
                await FirebaseAuth.instance.signOut();
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
            const Text(
              "Welcome Teacher 👩‍🏫",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("My Students"),
                subtitle: const Text("Students assigned to you"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const StudentListScreen(),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle),
                title: const Text("Mark Attendance"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MarkAttendanceScreen()),
                  );
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Attendance History"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AttendanceHistoryScreen(),
                    ),
                  );
                },
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text("Upload Notes"),
                subtitle: const Text("Share study materials"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UploadNotesScreen()),
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

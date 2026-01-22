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

            // 🔥 REAL FEATURE
            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text("View Students"),
                subtitle: const Text("See all students in your class"),
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

            // Placeholders
            const Card(
              child: ListTile(
                leading: Icon(Icons.check_circle),
                title: Text("Mark Attendance"),
                subtitle: Text("Mark daily attendance"),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.upload_file),
                title: Text("Upload Notes"),
                subtitle: Text("Share study materials"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

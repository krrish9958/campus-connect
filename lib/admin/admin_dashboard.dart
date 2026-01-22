import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_management_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
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
              "Welcome Admin 🛡️",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Admin Features (placeholders)
            Card(
              child: ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text("Manage Users"),
                subtitle: const Text("View all users and assign roles"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserManagementScreen(),
                    ),
                  );
                },
              ),
            ),

            const Card(
              child: ListTile(
                leading: Icon(Icons.security),
                title: Text("Assign Roles"),
                subtitle: Text("Promote users to teacher or admin"),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.analytics),
                title: Text("System Overview"),
                subtitle: Text("View app usage and stats"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Users")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              final email = data['email'] ?? 'No Email';
              final role = data['role'] ?? 'unknown';

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(email),
                  subtitle: Text("Role: $role"),
                  trailing: const Icon(Icons.edit),
                  onTap: () {
                    _showRoleDialog(context, doc.id, email, role);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showRoleDialog(
    BuildContext context,
    String uid,
    String email,
    String currentRole,
  ) {
    String selectedRole = currentRole;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change User Role"),
          content: DropdownButtonFormField<String>(
            value: selectedRole,
            items: const [
              DropdownMenuItem(value: 'student', child: Text('Student')),
              DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
            ],
            onChanged: (value) {
              if (value != null) {
                selectedRole = value;
              }
            },
            decoration: const InputDecoration(labelText: "Role"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final admin = FirebaseAuth.instance.currentUser!;

                final oldRole = currentRole;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'role': selectedRole});

                // 🔥 WRITE AUDIT LOG
                await FirebaseFirestore.instance.collection('audit_logs').add({
                  'action': 'CHANGE_ROLE',
                  'targetUserId': uid,
                  'targetEmail': email,
                  'oldRole': oldRole,
                  'newRole': selectedRole,
                  'changedBy': admin.uid,
                  'changedByEmail': admin.email,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}

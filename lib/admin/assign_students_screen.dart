import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignStudentsScreen extends StatelessWidget {
  final String studentId;
  final String studentName;

  const AssignStudentsScreen({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Assign $studentName")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'teacher')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final teachers = snapshot.data!.docs;

          if (teachers.isEmpty) {
            return const Center(child: Text("No teachers found"));
          }

          return ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              final teacher = teachers[index];
              final data = teacher.data() as Map<String, dynamic>;

              return ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  (data['name'] != null && data['name'].toString().isNotEmpty)
                      ? data['name']
                      : (data['email'] ?? 'Teacher'),
                ),

                subtitle: Text(data['email'] ?? ''),

                onTap: () async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('students')
                        .doc(studentId)
                        .update({'assignedTeacherId': teacher.id});

                    if (!context.mounted) return;

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Student assigned successfully"),
                      ),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

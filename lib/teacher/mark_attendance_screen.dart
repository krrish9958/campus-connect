import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/attendance_service.dart';

class MarkAttendanceScreen extends StatefulWidget {
  MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final Map<String, bool> attendance = {};
  final _service = AttendanceService();

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text("Mark Attendance")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .where(
              'assignedTeacherId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final students = snapshot.data!.docs;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final doc = students[index];
              final data = doc.data() as Map<String, dynamic>;

              return CheckboxListTile(
                title: Text(data['name']),
                subtitle: Text(data['rollNo']),
                value: attendance[doc.id] ?? false,
                onChanged: (value) async {
                  setState(() {
                    attendance[doc.id] = value!;
                  });

                  await _service.markAttendance(
                    studentId: doc.id,
                    present: value!,
                    date: today,
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text("Save Attendance"),
        onPressed: () async {
          for (final entry in attendance.entries) {
            await _service.markAttendance(
              studentId: entry.key,
              present: entry.value,
              date: today,
            );
          }

          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Attendance saved")));
        },
      ),
    );
  }
}

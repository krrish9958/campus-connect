import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final teacherId = FirebaseAuth.instance.currentUser!.uid;
    final dateKey = selectedDate.toIso8601String().split('T')[0];

    return Scaffold(
      appBar: AppBar(title: const Text("Attendance History")),
      body: Column(
        children: [
          ListTile(
            title: Text("Date: $dateKey"),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                initialDate: selectedDate,
              );

              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .doc(teacherId)
                  .collection(dateKey)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final records = snapshot.data!.docs;

                if (records.isEmpty) {
                  return const Center(child: Text("No attendance found"));
                }

                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final data = records[index].data() as Map<String, dynamic>;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('students')
                          .doc(records[index].id)
                          .get(),
                      builder: (context, studentSnap) {
                        if (!studentSnap.hasData) {
                          return const SizedBox.shrink();
                        }

                        if (!studentSnap.data!.exists) {
                          return const ListTile(
                            title: Text(
                              "Student record not found",
                              style: TextStyle(color: Colors.red),
                            ),
                            subtitle: Text("This attendance entry is invalid"),
                          );
                        }

                        final student =
                            studentSnap.data!.data() as Map<String, dynamic>;

                        return ListTile(
                          leading: Icon(
                            data['present'] ? Icons.check_circle : Icons.cancel,
                            color: data['present'] ? Colors.green : Colors.red,
                          ),
                          title: Text(student['name']),
                          subtitle: Text(
                            "Roll No: ${student['rollNo']} • ${data['present'] ? 'Present' : 'Absent'}",
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

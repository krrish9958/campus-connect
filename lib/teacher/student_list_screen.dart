import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final StudentService _service = StudentService();

  late Future<List<StudentModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.getAllStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Students")),
      body: FutureBuilder<List<StudentModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final students = snapshot.data ?? [];

          if (students.isEmpty) {
            return const Center(child: Text("No students found"));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final s = students[index];

              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(s.name),
                  subtitle: Text(
                    "Roll: ${s.rollNo} | ${s.branch} | Year ${s.year}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

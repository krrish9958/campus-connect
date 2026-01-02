import 'package:campus_connect/providers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  @override
  void initState() {
    super.initState();

    // ✅ call ONCE after widget is mounted
    Future.microtask(() {
      context.read<StudentProvider>().loadStudent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    if (provider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final student = provider.student;

    if (student == null) {
      return const Scaffold(body: Center(child: Text("No student data")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Student Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${student.name}"),
            Text("Roll No: ${student.rollNo}"),
            Text("Branch: ${student.branch}"),
            Text("Year: ${student.year}"),
            Text("Email: ${student.email}"),
          ],
        ),
      ),
    );
  }
}

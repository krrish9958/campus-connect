import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';

class EditStudentProfileScreen extends StatefulWidget {
  const EditStudentProfileScreen({super.key});

  @override
  State<EditStudentProfileScreen> createState() =>
      _EditStudentProfileScreenState();
}

class _EditStudentProfileScreenState extends State<EditStudentProfileScreen> {
  final nameCtrl = TextEditingController();
  final rollCtrl = TextEditingController();
  final branchCtrl = TextEditingController();
  final yearCtrl = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final student = context.read<StudentProvider>().student;

      if (student != null) {
        nameCtrl.text = student.name;
        rollCtrl.text = student.rollNo;
        branchCtrl.text = student.branch;
        yearCtrl.text = student.year.toString();
      }

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rollCtrl,
              decoration: const InputDecoration(labelText: "Roll No"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: branchCtrl,
              decoration: const InputDecoration(labelText: "Branch"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: yearCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Year"),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await provider.updateStudentProfile(
                    name: nameCtrl.text.trim(),
                    rollNo: rollCtrl.text.trim(),
                    branch: branchCtrl.text.trim(),
                    year: int.tryParse(yearCtrl.text) ?? 1,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

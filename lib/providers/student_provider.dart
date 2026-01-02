import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import 'package:flutter/widgets.dart';

class StudentProvider extends ChangeNotifier {
  final StudentService _service = StudentService();

  StudentModel? student;
  bool isLoading = false;

  Future<void> loadStudent() async {
    if (isLoading) return;

    isLoading = true;

    student = await _service.getOrCreateStudent();

    isLoading = false;
    notifyListeners();
  }
}

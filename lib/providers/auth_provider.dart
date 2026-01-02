import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      await _authService.login(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
      debugPrint("FIREBASE AUTH ERROR: ${e.code} - ${e.message}");
      return false;
    } catch (e) {
      errorMessage = e.toString();
      debugPrint("UNKNOWN LOGIN ERROR: $e");
      return false;
    } finally {
      notifyListeners();
    }
  }
}

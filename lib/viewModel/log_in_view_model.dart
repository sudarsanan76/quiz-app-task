import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/views/admin_dashboard.dart';
import 'package:quiz_app/views/user_dashboard.dart';

/// [LoginViewModel] acts as view model for log in screen
class LoginViewModel {
  // Controllers to be linked to the TextFields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Logic Function
  void handleLogin(String selectedRole) {
    String user = usernameController.text.trim();
    String pass = passwordController.text.trim();
    if (selectedRole == 'admin') {
      if (user == 'admin' && pass == '123') {
        Get.off(() => AdminDashboard());
      } else {
        _showError("Invalid Admin credentials");
      }
    } else {
      if (user == 'user' && pass == '1234') {
        Get.off(() => UserDashboard());
      } else {
        _showError("Invalid User credentials");
      }
    }
  }
  
  // show error
  void _showError(String message) {
    Get.snackbar(
      "Login Failed",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
    );
  }
}

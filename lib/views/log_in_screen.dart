import 'package:flutter/material.dart';
import 'package:quiz_app/viewModel/log_in_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'user'; // Default value
  // Initialize the ViewModel
  final LoginViewModel viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Quiz App",
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 20),
              // Username Field
              TextFormField(
                controller: viewModel.usernameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 20),

              // Password Field
              TextFormField(
                obscureText: true,
                controller: viewModel.passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              SizedBox(height: 20),

              // Radio Buttons for Role Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: 'user',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  Text("User"),
                  SizedBox(width: 30),
                  Radio<String>(
                    value: 'admin',
                    groupValue: _selectedRole,
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                  Text("Admin"),
                ],
              ),

              SizedBox(height: 30),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    viewModel.handleLogin(_selectedRole);
                  },
                  child: Text("LOGIN"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

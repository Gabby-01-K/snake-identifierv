// lib/pages/login_page.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field state
  String _email = '';
  String _password = '';
  String _error = '';
  bool _isLoading = false;

  // We add this to toggle between Login and Register
  bool _isLoginPage = true;

  // This function will handle both login and register
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      dynamic result;
      if (_isLoginPage) {
        result = await _auth.signInWithEmail(_email, _password);
      } else {
        result = await _auth.registerWithEmail(_email, _password);
      }

      setState(() => _isLoading = false);

      // --- MODIFIED LOGIC ---
      // Check if the result is a String, which means it's our error message
      if (result is String) {
        setState(() => _error = result);
      }
      // If result is not a String and not a User, something else went wrong
      else if (result == null || result is! User) {
        setState(() => _error = 'An error occurred. Please check your details.');
      }
      // If successful, the AuthWrapper will automatically handle the navigation
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoginPage ? 'Login' : 'Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                'Welcome to Snake Identifier',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) => setState(() => _email = val),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (val) =>
                val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) => setState(() => _password = val),
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: _submitForm,
                child: Text(_isLoginPage ? 'Login' : 'Create Account'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginPage = !_isLoginPage; // Toggle the view
                    _error = '';
                    _formKey.currentState!.reset();
                  });
                },
                child: Text(_isLoginPage
                    ? 'Need an account? Register'
                    : 'Have an account? Login'),
              ),
              const SizedBox(height: 12),
              if (_error.isNotEmpty)
                Text(
                  _error,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
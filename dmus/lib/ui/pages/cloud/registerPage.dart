
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationWidget extends StatefulWidget {
  @override
  State<RegistrationWidget> createState() => _RegistrationWidgetState();
}

class _RegistrationWidgetState extends State<RegistrationWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordValid = true;
  bool _isEmailValid = true;
  Color _snackBarColor = Colors.red; // Snackbar color

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor, // Set the Snackbar color
      ),
    );
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void _register() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || !_validateEmail(email)) {
      setState(() {
        _isEmailValid = false;
        _snackBarColor = Colors.red; // Set the color for email validation error
      });
      _showSnackBar('Please enter a valid email address.', _snackBarColor);
      return;
    } else {
      setState(() {
        _isEmailValid = true;
      });
    }

    if (password.length < 6) {
      setState(() {
        _isPasswordValid = false;
        _snackBarColor = Colors.red; // Set the color for password validation error
      });
      _showSnackBar('Password must be at least 6 characters long.', _snackBarColor);
      return;
    } else {
      setState(() {
        _isPasswordValid = true;
      });
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _snackBarColor = Colors.green; // Set the color for successful registration
        _showSnackBar('Registration successful', _snackBarColor);
        popNavigatorSafe(context);
        popNavigatorSafe(context);
      }
    } catch (e) {
      _showSnackBar('Registration failed. Error: $e', _snackBarColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText: _isEmailValid ? null : 'Please enter a valid email address.',
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _isPasswordValid ? null : 'Password must be at least 6 characters long.',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: RegistrationWidget(),
  ));
}

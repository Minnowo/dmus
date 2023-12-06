
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Settings.dart';
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
  bool _isLoading = false;
  bool _obscureText = false; // Initially obscure the password
  Color _snackBarColor = Colors.red;

  void _showSnackBar(String message, Color backgroundColor) {
    showSnackBarWithDuration(context, message, longSnackBarDuration, color: backgroundColor);
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || !_validateEmail(email)) {
      setState(() {
        _isEmailValid = false;
        _snackBarColor = Colors.red;
        _isLoading = false;
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
        _snackBarColor = Colors.red;
        _isLoading = false;
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
        _snackBarColor = Colors.green;
        _showSnackBar('Registration successful', _snackBarColor);
        popNavigatorSafe(context);
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar('Registration failed. Error: ${e.message}', _snackBarColor);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                  errorText: _isEmailValid ? null : LocalizationMapper.current.enterValidEmail,
                ),
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  errorText: _isPasswordValid ? null : LocalizationMapper.current.minPasswordLen,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text(LocalizationMapper.current.register),
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

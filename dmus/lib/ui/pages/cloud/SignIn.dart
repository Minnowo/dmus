import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key}) : super(key: key);

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isEmailEmpty = false;
  bool _isPasswordEmpty = false;
  bool _obscureText = false;

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty) {
      setState(() {
        _isEmailEmpty = true;
      });
    } else {
      setState(() {
        _isEmailEmpty = false;
      });
    }

    if (password.isEmpty) {
      setState(() {
        _isPasswordEmpty = true;
      });
    } else {
      setState(() {
        _isPasswordEmpty = false;
      });
    }

    if (_isEmailEmpty || _isPasswordEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        _showSnackBar("Signed in: ${userCredential.user?.email}", Colors.green);

        popNavigatorSafe(context);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        _showSnackBar('Incorrect password. Please try again.', Colors.red);
      } else if (e.code == 'user-not-found') {
        _showSnackBar('Email not found. Please check your email address.', Colors.red);
      } else {
        _showSnackBar('Sign-In Error: ${e.message}', Colors.red);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationMapper.current.signIn),
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
                  labelText: LocalizationMapper.current.email,
                  errorText: _isEmailEmpty ? LocalizationMapper.current.emailEmpty : null,
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: LocalizationMapper.current.password,
                  errorText: _isPasswordEmpty ? LocalizationMapper.current.passwordEmpty : null,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(height: 16.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _signIn,
                child: Text(LocalizationMapper.current.signIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

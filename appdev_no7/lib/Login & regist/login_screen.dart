
import 'package:appdev_no7/firebase_auth_service.dart/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:appdev_no7/Main/main.dart'; // Assuming you are using MainScaffold in the project
import 'register.dart'; // Import the RegisterScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyVocab'),
      ),
      resizeToAvoidBottomInset: true, // Prevents overflow when keyboard appears
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Move image a little bit up
            Transform.translate(
              offset: Offset(0, -20), // Move the image 20 pixels up
              child: Image.asset(
                'assets/icon/MyVocab.png',
                height: 200,
                width: 200,
              ),
            ),
            
            SizedBox(height: 20),

            // Username TextField
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),

            // Password TextField
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _signIn,
              child: Text('Login'),
            ),

            SizedBox(height: 20),

            // Updated Register button
            TextButton(
              onPressed: () {
                // Navigate to RegisterScreen when clicked
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text('Don\'t have an account? Register here.'),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.SignInemailandpassword(email, password);

    if (user != null) {
      print("User is successfully Signin");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScaffold()),
      );
    } else {
      print("Some error happened");
    }
  }
}
import 'package:flutter/material.dart';
import 'package:appdev_no7/Main/main.dart'; // Assuming you are using MainScaffold in the project
import 'register.dart'; // Import the RegisterScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyVocab'),
      ),
      body: Padding(
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
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
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
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;

                // Validate login credentials
                if (username == 'user' && password == 'pass') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScaffold()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid username or password')),
                  );
                }
              },
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
}

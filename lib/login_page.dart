import 'package:flutter/material.dart';
import 'main.dart'; // Import main.dart for navigation to MainPage

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String _correctUsername = "user123";
  final String _correctPassword = "password123";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginStatus = "";

  void _handleLogin() {
    if (_usernameController.text == _correctUsername &&
        _passwordController.text == _correctPassword) {
      // Navigate to MainPage (home page) after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } else {
      setState(() {
        _loginStatus = "Invalid username or password.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          // This hides the keyboard when tapping outside of the text fields
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7FA643), // Use your app's color scheme
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameController,
                textInputAction: TextInputAction.next, // Ensure keyboard works
                decoration: InputDecoration(
                  labelText: "Username",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF7FA643)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.done, // Ensure keyboard works
                decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF7FA643)),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7FA643),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black, // Always black text
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _loginStatus,
                style: TextStyle(
                  color: _loginStatus == "Login Successful!"
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

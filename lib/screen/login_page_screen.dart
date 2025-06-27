import 'package:flutter/material.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  // State to manage password visibility
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    // Scaffold is the base for our page
    return Scaffold(
      // We use a Stack to place the login form ON TOP of the background image
      body: Stack(
        fit: StackFit.expand, // Make the stack's children fill the screen
        children: [
          // 1. The Background Image
          Image.asset(
            'assets/images/palm_background.jpg',
            fit: BoxFit.cover, // Cover the entire screen
          ),

          // 2. The Login Form
          Center(
            child: SingleChildScrollView(
              // Prevents overflow when keyboard appears
              padding: const EdgeInsets.all(10.0),
              child: _buildLoginForm(),
            ),
          ),
        ],
      ),
    );
  }

  // Extracted the form into a separate method for clarity
  Widget _buildLoginForm() {
    return Container(
      // This is the white card
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // The column should wrap its content
        children: [
          // Logo
          Image.asset(
            'assets/images/aal_logo.png',
            height: 150, // Adjust height as needed
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Email', style: TextStyle(color: Colors.black54)),
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),

          // Password Label
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Password', style: TextStyle(color: Colors.black54)),
          ),
          const SizedBox(height: 8),

          // Password TextField
          TextField(
            obscureText: _isPasswordObscured, // Use state variable here
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: IconButton(
                icon: Icon(
                  // Change icon based on state
                  _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  // Update the state to toggle visibility
                  setState(() {
                    _isPasswordObscured = !_isPasswordObscured;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Login Button
          ElevatedButton(
            onPressed: () {
              // Handle login logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF16A55C), // The specific green color
              minimumSize: const Size(double.infinity, 50), // Make button wide
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

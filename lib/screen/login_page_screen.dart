import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sawit/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPageScreen extends StatefulWidget {
  const LoginPageScreen({super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  // State to manage password visibility
  bool _isPasswordObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String> _getDeviceName() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      return 'Unknown Device';
    }
    return 'Web/Desktop Device';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/palm_background.jpg',
                fit: BoxFit.cover,
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: _buildLoginForm(state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(AuthState state) {
    return Container(
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
            controller: _emailController,
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

          TextField(
            controller: _passwordController,
            obscureText: _isPasswordObscured,
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
            onPressed: state is AuthLoading
                ? null
                : () async {
                    final email = _emailController.text;
                    final password = _passwordController.text;

                    // Validasi sederhana
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Email dan Password harus diisi!')),
                      );
                      return;
                    }

                    // Ambil Device ID
                    final deviceName = await _getDeviceName();

                    // Trigger (Tembak) Event BLoC
                    if (context.mounted) {
                      context.read<AuthBloc>().add(
                            LoginRequested(email, password, deviceName),
                          );
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF16A55C), // The specific green color
              minimumSize: const Size(double.infinity, 50), // Make button wide
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: state is AuthLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ],
      ),
    );
  }
}

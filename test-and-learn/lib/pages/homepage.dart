import 'package:flutter/material.dart';
import 'package:test_and_learn/pages/registrationpage.dart';
import 'loginpage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Optional
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo or Icon
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/logo.png'), // Put your logo in assets folder
                // backgroundColor: Colors.transparent,
              ),

              const SizedBox(height: 24),

              // Welcome Text
              const Text(
                'Welcome to Global Tech!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),
              const Text(
                'Manage your products, inventory, and orders with ease.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blueAccent,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Register Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Registration()),
                    );
                  },
                  icon: const Icon(Icons.app_registration),
                  label: const Text('Register'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

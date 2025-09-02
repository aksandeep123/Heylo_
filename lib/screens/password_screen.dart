import 'package:flutter/material.dart';
import 'package:heylo/colors.dart';
import 'package:heylo/utils/responsive_layout.dart';
import 'package:heylo/screens/mobile_layout_screen.dart';
import 'package:heylo/screens/web_layout_screen.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final String correctPassword = "123456";

  void checkPassword() {
    if (passwordController.text == correctPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileLayoutScreen(),
            webScreenLayout: WebLayoutScreen(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Wrong password! Try 123456'),
          backgroundColor: Colors.red,
        ),
      );
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock,
                size: 80,
                color: tabColor,
              ),
              const SizedBox(height: 30),
              const Text(
                'Enter Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, letterSpacing: 2),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: tabColor),
                  ),
                ),
                onSubmitted: (_) => checkPassword(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: checkPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tabColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Unlock',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
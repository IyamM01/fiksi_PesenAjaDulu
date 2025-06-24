import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> handleSignup() async {
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (username.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      showError("Semua field harus diisi!");
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'phone': phone,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/signin');
      } else {
        showError(data['message'] ?? 'Gagal mendaftar.');
      }
    } catch (e) {
      showError("Terjadi kesalahan koneksi.");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2B2937),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign Up to Create Account',
              style: TextStyle(fontSize: 16, color: Color(0xFF504F5E)),
            ),
            const SizedBox(height: 48),

            _buildLabel("Username"),
            _buildInput(
              usernameController,
              'Your Username',
              'assets/icon/user.png',
            ),

            const SizedBox(height: 24),
            _buildLabel("Phone Number"),
            _buildInput(
              phoneController,
              'Your Phone Number',
              'assets/icon/phone.png',
              type: TextInputType.phone,
            ),

            const SizedBox(height: 24),
            _buildLabel("Email Address"),
            _buildInput(
              emailController,
              'Your Email Address',
              'assets/icon/email.png',
            ),

            const SizedBox(height: 24),
            _buildLabel("Password"),
            _buildPasswordInput(),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isLoading ? null : handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account? ",
                  style: TextStyle(color: Color(0xFF4E4E4E)),
                ),
                GestureDetector(
                  onTap:
                      () => Navigator.pushReplacementNamed(context, '/signin'),
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Color(0xFFFF8700),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2B2937),
      ),
    );
  }

  Widget _buildInput(
    TextEditingController controller,
    String hint,
    String iconPath, {
    TextInputType type = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDDD8FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(iconPath, width: 24, height: 24),
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1DA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: passwordController,
        obscureText: isPasswordHidden,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/icon/lock.png', width: 24, height: 24),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() => isPasswordHidden = !isPasswordHidden);
            },
          ),
          hintText: 'Your Password',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

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
                        
            // Username label
            const Text(
              'Username',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: Color(0xFF2B2937)),
            ),
            const SizedBox(height: 8),

            /// Username Input
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDDD8FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/icon/user.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  hintText: 'Your Username',
                  border: InputBorder.none,
                ),
                ),
            ),
            const SizedBox(height: 24),

            /// Email Label
            const Text(
              'Email Address',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w600, 
                color: Color(0xFF2B2937)),
            ),
            const SizedBox(height: 8),

            /// Email Input
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFDDD8FB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/icon/email.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  hintText: 'Your Email Address',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),

            /// Password Label
            const Text(
              'Password',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            /// Password Input
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1DA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/icon/lock.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  hintText: 'Your Password',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 40),

            /// Sign In Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8700),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),

            const Spacer(),

            /// Sign Up Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Have an account? ",
                  style: TextStyle(color: Color(0xFF4E4E4E)),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
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
}

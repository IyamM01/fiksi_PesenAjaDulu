import 'package:flutter/material.dart';
import 'package:flutter_fiksi/pages/login.dart';
import 'package:flutter_fiksi/pages/welcome.dart';
import 'package:flutter_fiksi/pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Fiksi',
      theme: ThemeData(
        fontFamily: 'Poppins', // atau 'Popins' jika kamu tetap pakai itu
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/login': (context) => const LoginPage(), // pastikan LoginPage sudah diimport
        '/signup': (context) => const SignupPage(), // pastikan SignUp sudah diimport
        '/signin': (context) => const LoginPage(), // pastikan SignIn sudah diimport
      },
    );
  }
}

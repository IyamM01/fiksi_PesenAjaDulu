import 'package:flutter/material.dart';
import 'package:flutter_fiksi/pages/home.dart';
import 'package:flutter_fiksi/pages/login.dart';
import 'package:flutter_fiksi/pages/payment_done.dart';
import 'package:flutter_fiksi/pages/signup.dart';
import 'package:flutter_fiksi/pages/checkout.dart';
import 'package:flutter_fiksi/pages/order_menu.dart';
import 'package:flutter_fiksi/pages/resto.dart';
import 'package:flutter_fiksi/pages/payment.dart';
import 'package:flutter_fiksi/pages/payment_done.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PesenAjaDulu',
      theme: ThemeData(
        fontFamily: 'Poppins', // atau 'Popins' jika kamu tetap pakai itu
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const CheckoutPage(),
        '/login':
            (context) => const LoginPage(), // pastikan LoginPage sudah diimport
        '/signup':
            (context) => const SignupPage(), // pastikan SignUp sudah diimport
        '/signin':
            (context) => const LoginPage(), // pastikan SignIn sudah diimport
        '/home':
            (context) => const HomePage(), // pastikan MyWidget sudah diimport
        '/order_menu': (context) => const OrderMenuPage(),
        '/payment': (context) => const PaymentPage(),
        '/payment_done': (context) => const PaymentDone(),
      },
    );
  }
}

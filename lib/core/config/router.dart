import 'package:go_router/go_router.dart';

import 'package:flutter_fiksi/features/home/presentation/home.dart';
import 'package:flutter_fiksi/features/auth/presentation/login.dart';
import 'package:flutter_fiksi/features/auth/presentation/signup.dart';
import 'package:flutter_fiksi/features/order/presentation/order_menu.dart';
import 'package:flutter_fiksi/features/order/presentation/checkout.dart';
import 'package:flutter_fiksi/features/order/presentation/payment.dart';
import 'package:flutter_fiksi/features/order/presentation/payment_done.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/resto.dart';
import 'package:flutter_fiksi/features/table/presentation/table_order.dart';
import 'package:flutter_fiksi/core/presentation/pages/welcome_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomePage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(
      path: '/order_menu',
      builder: (context, state) => const OrderMenuPage(),
    ),
    GoRoute(
      path: '/table_order',
      builder: (context, state) => const TableOrder(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutPage(),
    ),
    GoRoute(path: '/payment', builder: (context, state) => const PaymentPage()),
    GoRoute(
      path: '/payment_done',
      builder: (context, state) => const PaymentDone(),
    ),
    GoRoute(path: '/resto', builder: (context, state) => const Resto()),
  ],
);

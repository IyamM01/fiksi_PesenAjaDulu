import 'package:go_router/go_router.dart';

import 'package:flutter_fiksi/features/home/presentation/main_navigation_wrapper.dart';
import 'package:flutter_fiksi/features/auth/presentation/login.dart';
import 'package:flutter_fiksi/features/auth/presentation/signup.dart';
import 'package:flutter_fiksi/features/order/presentation/order_menu.dart';
import 'package:flutter_fiksi/features/order/presentation/checkout.dart';
import 'package:flutter_fiksi/features/order/presentation/payment.dart';
import 'package:flutter_fiksi/features/order/presentation/payment_done.dart';
import 'package:flutter_fiksi/features/restaurant/presentation/resto.dart';
import 'package:flutter_fiksi/features/order/presentation/table_order.dart';
import 'package:flutter_fiksi/features/order/presentation/payment_summary.dart';
import 'package:flutter_fiksi/features/order/presentation/payment_webview.dart';
import 'package:flutter_fiksi/features/order/presentation/order_verification.dart';
import 'package:flutter_fiksi/features/order/presentation/order_success.dart';
import 'package:flutter_fiksi/core/presentation/pages/welcome_page.dart';
import 'package:flutter_fiksi/core/presentation/pages/app_startup.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AppStartupScreen()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomePage()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationWrapper(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
    GoRoute(
      path: '/order_menu',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OrderMenuPage(
          restaurantId: extra?['restaurantId'],
          restaurantName: extra?['restaurantName'],
        );
      },
    ),
    GoRoute(
      path: '/table_order',
      builder: (context, state) => const TableOrder(),
    ),
    GoRoute(
      path: '/payment_summary',
      builder: (context, state) => const PaymentSummaryPage(),
    ),
    GoRoute(
      path: '/payment-webview',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PaymentWebViewPage(
          snapUrl: extra?['snapUrl'] ?? '',
          orderId: extra?['orderId'] ?? '',
          orderNumber: extra?['orderNumber'] ?? '',
          onlineAmount: extra?['onlineAmount'],
          restaurantAmount: extra?['restaurantAmount'],
          totalAmount: extra?['totalAmount'],
        );
      },
    ),
    GoRoute(
      path: '/order_verification',
      builder: (context, state) => const OrderVerificationPage(),
    ),
    GoRoute(
      path: '/order-success',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return OrderSuccessPage(
          orderId: extra?['orderId'] ?? '',
          orderNumber: extra?['orderNumber'] ?? '',
          onlineAmount: extra?['onlineAmount'] ?? '0',
          restaurantAmount: extra?['restaurantAmount'] ?? '0',
          totalAmount: extra?['totalAmount'] ?? '0',
        );
      },
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

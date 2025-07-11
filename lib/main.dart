import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_fiksi/core/config/router.dart';
import 'package:flutter_fiksi/core/theme/app_theme.dart';
import 'package:flutter_fiksi/core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await DependencyInjection.init();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'PesenAjaDulu',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

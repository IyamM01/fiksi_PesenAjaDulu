import 'package:flutter/material.dart';
import 'package:flutter_fiksi/core/config/router.dart';
import 'package:flutter_fiksi/core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
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

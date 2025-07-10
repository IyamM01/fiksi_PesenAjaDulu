import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppConstants.fontFamily,
      colorScheme: const ColorScheme.light(
        primary: Color(AppConstants.primaryColor),
        secondary: Color(AppConstants.textSecondaryColor),
        surface: Color(AppConstants.backgroundColor),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(AppConstants.textPrimaryColor),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(AppConstants.textPrimaryColor),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textPrimaryColor),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(AppConstants.primaryColor),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(
            fontFamily: AppConstants.fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(AppConstants.textPrimaryColor),
        ),
        headlineMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textPrimaryColor),
        ),
        headlineSmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(AppConstants.textPrimaryColor),
        ),
        bodyLarge: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 16,
          color: Color(AppConstants.textPrimaryColor),
        ),
        bodyMedium: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 14,
          color: Color(AppConstants.textSecondaryColor),
        ),
        bodySmall: TextStyle(
          fontFamily: AppConstants.fontFamily,
          fontSize: 12,
          color: Color(AppConstants.textHintColor),
        ),
      ),
      cardTheme: CardTheme(
        color: const Color(AppConstants.cardColor),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(AppConstants.cardColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(AppConstants.primaryColor),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}

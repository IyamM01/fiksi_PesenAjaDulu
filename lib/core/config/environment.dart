import 'package:flutter/foundation.dart';

/// Environment configuration for the app
class Environment {
  /// Current environment type
  static const EnvironmentType _environmentType =
      kDebugMode ? EnvironmentType.development : EnvironmentType.production;

  /// Get current environment type
  static EnvironmentType get currentEnvironment => _environmentType;

  /// Check if current environment is development
  static bool get isDevelopment =>
      _environmentType == EnvironmentType.development;

  /// Check if current environment is staging
  static bool get isStaging => _environmentType == EnvironmentType.staging;

  /// Check if current environment is production
  static bool get isProduction =>
      _environmentType == EnvironmentType.production;

  /// Get base URL based on environment
  static String get baseUrl {
    switch (_environmentType) {
      case EnvironmentType.development:
        return _DevelopmentConfig.baseUrl;
      case EnvironmentType.staging:
        return _StagingConfig.baseUrl;
      case EnvironmentType.production:
        return _ProductionConfig.baseUrl;
    }
  }

  /// Get API timeout duration
  static Duration get apiTimeout {
    switch (_environmentType) {
      case EnvironmentType.development:
        return const Duration(seconds: 30);
      case EnvironmentType.staging:
        return const Duration(seconds: 25);
      case EnvironmentType.production:
        return const Duration(seconds: 20);
    }
  }

  /// Get connect timeout duration
  static Duration get connectTimeout {
    switch (_environmentType) {
      case EnvironmentType.development:
        return const Duration(seconds: 15);
      case EnvironmentType.staging:
        return const Duration(seconds: 12);
      case EnvironmentType.production:
        return const Duration(seconds: 10);
    }
  }

  /// Check if debug features should be enabled
  static bool get enableDebugFeatures => isDevelopment;

  /// Check if logging should be enabled
  static bool get enableLogging => isDevelopment || isStaging;

  /// Get environment name as string
  static String get environmentName {
    switch (_environmentType) {
      case EnvironmentType.development:
        return 'Development';
      case EnvironmentType.staging:
        return 'Staging';
      case EnvironmentType.production:
        return 'Production';
    }
  }
}

/// Environment types
enum EnvironmentType { development, staging, production }

/// Development environment configuration
class _DevelopmentConfig {
  static const String baseUrl = 'http://10.68.136.25:8000/api';
  // Alternative URLs for development
  // static const String baseUrl = 'http://127.0.0.1:8000/api'; // Local development
  // static const String baseUrl = 'http://localhost:8000/api';  // Local development alternative
}

/// Staging environment configuration
class _StagingConfig {
  static const String baseUrl = 'https://staging-api.pesenajaduluapp.com/api';
}

/// Production environment configuration
class _ProductionConfig {
  static const String baseUrl = 'https://pesenajadulu.my.id/api';
}

/// Environment utilities
class EnvironmentUtils {
  /// Get appropriate error message based on environment
  static String getErrorMessage(String debugMessage, String userMessage) {
    return Environment.isDevelopment ? debugMessage : userMessage;
  }

  /// Check if feature is enabled in current environment
  static bool isFeatureEnabled(String feature) {
    switch (feature) {
      case 'debug_panel':
        return Environment.isDevelopment;
      case 'crash_reporting':
        return Environment.isProduction || Environment.isStaging;
      case 'analytics':
        return Environment.isProduction;
      case 'performance_monitoring':
        return !Environment.isDevelopment;
      default:
        return false;
    }
  }

  /// Get configuration value based on environment
  static T getConfigValue<T>({
    required T development,
    required T staging,
    required T production,
  }) {
    switch (Environment.currentEnvironment) {
      case EnvironmentType.development:
        return development;
      case EnvironmentType.staging:
        return staging;
      case EnvironmentType.production:
        return production;
    }
  }
}

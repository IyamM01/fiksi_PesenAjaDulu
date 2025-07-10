class AppConstants {
  // App Information
  static const String appName = 'PesenAjaDulu';
  static const String appVersion = '1.0.0';

  // Colors
  static const int primaryColor = 0xFFFE7F00;
  static const int backgroundColor = 0xFFECDCDC;
  static const int cardColor = 0xFFFCECDC;
  static const int textPrimaryColor = 0xFF4E2A00;
  static const int textSecondaryColor = 0xFF754414;
  static const int textHintColor = 0xFF504F5E;

  // Asset Paths
  static const String logoPath = 'assets/image/logo.png';
  static const String promoImagePath = 'assets/image/promo.png';
  static const String menuImagePath = 'assets/image/menu.png';
  static const String tableImagePath = 'assets/image/table.png';
  static const String qrisImagePath = 'assets/image/qris.png';
  static const String mangEngkingImagePath = 'assets/image/mang_engking.png';

  // Icon Paths
  static const String profileIconPath = 'assets/icon/profile.png';
  static const String emailIconPath = 'assets/icon/email.png';
  static const String lockIconPath = 'assets/icon/lock.png';
  static const String phoneIconPath = 'assets/icon/phone.png';
  static const String userIconPath = 'assets/icon/user.png';
  static const String mejaIconPath = 'assets/icon/meja.png';

  // Font Family
  static const String fontFamily = 'Poppins';

  // API Endpoints (to be implemented)
  static const String baseUrl = 'https://api.pesenajadul.com';
  static const String authEndpoint = '/auth';
  static const String restaurantEndpoint = '/restaurants';
  static const String menuEndpoint = '/menu';
  static const String orderEndpoint = '/orders';
  static const String tableEndpoint = '/tables';

  // Cache Keys
  static const String userCacheKey = 'user_cache';
  static const String tokenCacheKey = 'auth_token';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxPhoneLength = 15;
}

# PesenAjaDulu - Flutter App Architecture

This document describes the refactored architecture of the PesenAjaDulu Flutter application following Clean Architecture principles and Domain-Driven Design.

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── router.dart                 # Go Router configuration
│   ├── constants/
│   │   └── app_constants.dart          # App-wide constants
│   ├── di/
│   │   └── dependency_injection.dart   # Dependency injection setup
│   ├── exceptions/
│   │   └── app_exceptions.dart         # Core exceptions
│   ├── presentation/
│   │   └── pages/
│   │       └── welcome_page.dart       # Welcome/Splash screen
│   ├── theme/
│   │   └── app_theme.dart             # App theme configuration
│   └── utils/
│       └── app_utils.dart             # Utility functions
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── signup_usecase.dart
│   │   ├── data/                      # To be implemented with JSON responses
│   │   └── presentation/
│   │       ├── login.dart
│   │       └── signup.dart
│   ├── home/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── promotion.dart
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_active_promotions_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       └── home.dart
│   ├── menu/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── menu_item.dart
│   │   │   │   └── menu_category.dart
│   │   │   ├── repositories/
│   │   │   │   └── menu_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_menu_items_usecase.dart
│   │   │       └── get_menu_items_by_restaurant_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       └── menu.dart
│   ├── order/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── order.dart
│   │   │   │   └── order_item.dart
│   │   │   ├── repositories/
│   │   │   │   └── order_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_order_usecase.dart
│   │   │       └── get_orders_by_user_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       ├── order_menu.dart
│   │       ├── checkout.dart
│   │       ├── payment.dart
│   │       └── payment_done.dart
│   ├── restaurant/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── restaurant.dart
│   │   │   ├── repositories/
│   │   │   │   └── restaurant_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_restaurants_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       └── resto.dart
│   ├── table/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── restaurant_table.dart
│   │   │   ├── repositories/
│   │   │   │   └── table_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_available_tables_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       └── table_order.dart
│   ├── history/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── order_history.dart
│   │   │   ├── repositories/
│   │   │   │   └── history_repository.dart
│   │   │   └── usecases/
│   │   │       └── get_order_history_usecase.dart
│   │   ├── data/                      # To be implemented
│   │   └── presentation/
│   │       └── history.dart
│   └── profile/
│       ├── domain/
│       │   ├── entities/
│       │   │   └── user_profile.dart
│       │   ├── repositories/
│       │   │   └── profile_repository.dart
│       │   └── usecases/
│       │       └── get_user_profile_usecase.dart
│       ├── data/                      # To be implemented
│       └── presentation/
│           └── profile.dart
├── shared/
│   ├── utils/
│   └── widgets/
└── main.dart
```

## 🏗️ Architecture Overview

### Clean Architecture Layers

1. **Domain Layer** (`domain/`)
   - **Entities**: Core business objects
   - **Repositories**: Abstract interfaces for data access
   - **Use Cases**: Business logic implementations

2. **Data Layer** (`data/`) - *To be implemented*
   - **Models**: Data transfer objects
   - **Data Sources**: Remote (API) and Local (Cache) data sources
   - **Repository Implementations**: Concrete implementations of domain repositories

3. **Presentation Layer** (`presentation/`)
   - **Pages/Widgets**: UI components
   - **State Management**: Will be implemented with Riverpod or Bloc

### Core Components

- **Router**: Centralized navigation using go_router
- **Theme**: Consistent UI theming across the app
- **Constants**: App-wide constants for colors, strings, etc.
- **Utils**: Common utility functions
- **Exceptions**: Custom exception handling

## 🚀 Key Features Implemented

### ✅ Domain Layer Complete
- User authentication entities and use cases
- Restaurant management entities and use cases
- Menu system with categories and items
- Order management with status tracking
- Table booking system
- Order history tracking
- User profile management
- Home promotions system

### ✅ Architecture Benefits
- **Separation of Concerns**: Each layer has a single responsibility
- **Testability**: Domain layer is independent and easily testable
- **Maintainability**: Clean structure makes code easy to maintain
- **Scalability**: Easy to add new features without affecting existing code
- **Dependency Inversion**: High-level modules don't depend on low-level modules

## 🔧 Next Steps

### Data Layer Implementation
When implementing the data layer, you'll need to:

1. **Create Models**: Data transfer objects that extend domain entities
2. **Implement Data Sources**: 
   - Remote data sources for API calls
   - Local data sources for caching
3. **Repository Implementations**: Concrete implementations using data sources
4. **Dependency Injection**: Set up service locator or dependency injection

### Example Data Layer Structure
```
data/
├── models/
│   ├── user_model.dart
│   ├── restaurant_model.dart
│   └── menu_item_model.dart
├── datasources/
│   ├── remote/
│   │   ├── auth_remote_datasource.dart
│   │   └── menu_remote_datasource.dart
│   └── local/
│       ├── auth_local_datasource.dart
│       └── menu_local_datasource.dart
└── repositories/
    ├── auth_repository_impl.dart
    └── menu_repository_impl.dart
```

## 📦 Dependencies

The app currently uses:
- `go_router` for navigation
- `flutter_riverpod` for state management
- `http` for API calls
- `mobile_scanner` for QR code scanning
- `url_launcher` for external links

## 🎨 UI/UX Features

- Custom theme with app-specific colors and fonts
- Consistent styling across all screens
- Responsive design patterns
- Material Design 3 components
- Custom widgets for reusability

## 🔒 Security Considerations

- Input validation utilities
- Exception handling for network errors
- Secure token storage (to be implemented)
- User session management

This refactored architecture provides a solid foundation for building a scalable, maintainable Flutter application following industry best practices.

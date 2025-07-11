# 🚀 How to Use Riverpod with Clean Architecture

This guide shows you exactly how to use your clean architecture with Riverpod for state management.

## ✅ What's Been Set Up:

### 1. **Main App with ProviderScope** ✅
```dart
// main.dart
void main() {
  runApp(
    ProviderScope(  // ✅ Wraps entire app
      child: const MyApp(),
    ),
  );
}
```

### 2. **Auth Providers** ✅
```dart
// auth_provider.dart
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});
```

### 3. **Login Page with Riverpod** ✅
```dart
// login.dart
class LoginPage extends ConsumerStatefulWidget {  // ✅ ConsumerStatefulWidget
  
  Future<void> _handleLogin() async {
    await ref.read(authProvider.notifier).login(  // ✅ Uses repository
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }
}
```

## 🎯 How to Use Throughout Your App:

### 📱 **1. In Any Widget (Consumer Pattern)**
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isAuthenticatedProvider);
    final user = ref.watch(currentUserProvider);
    
    return Text(isLoggedIn ? 'Hello ${user?.name}' : 'Please login');
  }
}
```

### 📱 **2. In StatefulWidget (ConsumerStatefulWidget)**
```dart
class MyStatefulWidget extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends ConsumerState<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    return ElevatedButton(
      onPressed: () {
        ref.read(authProvider.notifier).logout();
      },
      child: Text('Logout'),
    );
  }
}
```

### 📱 **3. Listen to State Changes**
```dart
@override
Widget build(BuildContext context) {
  // Listen for auth changes and show snackbars
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage!)),
      );
    }
  });
  
  return Scaffold(...);
}
```

## 🔄 **Data Flow Explanation:**

### 1. **UI Action** (User taps login button)
```dart
ElevatedButton(
  onPressed: () {
    ref.read(authProvider.notifier).login(email, password);  // 1. UI calls provider
  },
)
```

### 2. **Provider** (Handles state)
```dart
class AuthNotifier extends Notifier<AuthState> {
  Future<void> login({required String email, required String password}) async {
    final user = await _authRepository.login(email: email, password: password);  // 2. Provider calls repository
    state = state.copyWith(user: user, isLoggedIn: true);  // 3. Provider updates state
  }
}
```

### 3. **Repository** (Coordinates data sources)
```dart
class AuthRepositoryImpl implements AuthRepository {
  Future<User> login({required String email, required String password}) async {
    final loginData = await _remoteDataSource.login(email: email, password: password);  // 4. Repository calls API
    await _localDataSource.saveToken(token);  // 5. Repository saves to local storage
    return User.fromJson(loginData['user']);  // 6. Repository returns domain entity
  }
}
```

### 4. **UI Updates** (Automatically reacts to state changes)
```dart
Consumer(
  builder: (context, ref, child) {
    final isLoggedIn = ref.watch(isAuthenticatedProvider);  // 7. UI rebuilds when state changes
    return Text(isLoggedIn ? 'Welcome!' : 'Please login');
  },
)
```

## 📊 **Available Providers:**

### **Main Auth Provider:**
```dart
final authProvider  // Complete auth state
final isAuthenticatedProvider  // bool: is user logged in?
final currentUserProvider  // User?: current user data
final authLoadingProvider  // bool: is auth operation in progress?
final authErrorProvider  // String?: current error message
```

### **Usage Examples:**
```dart
// Check if loading
final isLoading = ref.watch(authLoadingProvider);

// Get current user
final user = ref.watch(currentUserProvider);

// Perform actions
ref.read(authProvider.notifier).login(email, password);
ref.read(authProvider.notifier).logout();
ref.read(authProvider.notifier).clearError();
```

## 🎯 **Best Practices:**

### ✅ **DO:**
- Use `ref.watch()` to read state and rebuild UI
- Use `ref.read()` to perform actions (login, logout)
- Use `ref.listen()` to react to state changes (show snackbars)
- Separate UI logic from business logic
- Handle errors gracefully

### ❌ **DON'T:**
- Use `ref.read()` inside build method for state
- Put business logic in widgets
- Forget to handle loading and error states
- Call providers from initState (use ref.listen instead)

## 🔥 **Quick Integration Guide:**

### **1. For New Pages:**
```dart
class NewPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isAuthenticatedProvider);
    
    if (!isLoggedIn) {
      return LoginPage();
    }
    
    return YourPageContent();
  }
}
```

### **2. For API Calls:**
```dart
// Your providers automatically use the repository with all error handling!
await ref.read(authProvider.notifier).login(email, password);
```

### **3. For Navigation:**
```dart
ref.listen<AuthState>(authProvider, (previous, next) {
  if (next.isLoggedIn) {
    context.go('/home');  // Navigate when login succeeds
  }
});
```

## 🎉 **You're Ready!**

Your app now has:
- ✅ Clean Architecture
- ✅ Riverpod State Management  
- ✅ Automatic error handling
- ✅ Reactive UI updates
- ✅ Proper dependency injection
- ✅ Token management
- ✅ Form validation

Just use the providers in your widgets and everything will work seamlessly! 🚀

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../domain/entities/user.dart';
import '../../../../core/exceptions/app_exceptions.dart';

// ============================================================================
// 🏗️ PROVIDERS - Dependency Injection with Riverpod
// ============================================================================

/// Remote data source provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

/// Local data source provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl();
});

/// Repository provider
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
    localDataSource: ref.read(authLocalDataSourceProvider),
  );
});

// ============================================================================
// 🚀 APP INITIALIZATION PROVIDER
// ============================================================================

/// App initialization state
enum AppInitState { loading, completed, error }

/// App initialization provider - handles initial auth state check
final appInitProvider = FutureProvider<AppInitState>((ref) async {
  try {
    // Add timeout to prevent indefinite hanging
    await Future.any([
      ref.read(authProvider.notifier).checkInitialAuthState(),
      Future.delayed(const Duration(seconds: 8)), // Max 8 seconds for init
    ]);
    return AppInitState.completed;
  } catch (e) {
    return AppInitState.error;
  }
});

// ============================================================================
// 📱 AUTH STATE - Simple State Management
// ============================================================================

/// Authentication state
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isLoggedIn;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isLoggedIn = false,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool? isLoggedIn,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

/// Auth state notifier using AsyncNotifier (simpler approach)
class AuthNotifier extends Notifier<AuthState> {
  late AuthRepositoryImpl _authRepository;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    // Don't call async operations in build() - it blocks UI
    // Initialize with default state and check auth state lazily
    return const AuthState();
  }

  /// Check if user is already logged in - call this manually when needed
  Future<void> checkInitialAuthState() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // Check login status (local only, fast)
      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        // Try to get user data (with timeout)
        try {
          final user = await _authRepository.getCurrentUser().timeout(
            const Duration(seconds: 5),
          );

          if (user != null) {
            state = state.copyWith(
              user: user,
              isLoggedIn: true,
              isLoading: false,
            );
          } else {
            // User data not available, but token exists - partial login state
            state = state.copyWith(
              isLoggedIn: true,
              isLoading: false,
              errorMessage: 'User data unavailable, please refresh',
            );
          }
        } catch (e) {
          // Network error getting user data, but user is still logged in locally
          state = state.copyWith(
            isLoggedIn: true,
            isLoading: false,
            errorMessage: 'Network error loading profile',
          );
        }
      } else {
        state = state.copyWith(isLoading: false, isLoggedIn: false);
      }
    } catch (e) {
      // Complete failure - treat as not logged in
      state = state.copyWith(
        isLoading: false,
        isLoggedIn: false,
        errorMessage: 'Failed to initialize auth state',
      );
    }
  }

  /// Login method
  Future<void> login({required String email, required String password}) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      final user = await _authRepository.login(
        email: email,
        password: password,
      );

      state = state.copyWith(user: user, isLoggedIn: true, isLoading: false);
    } on ValidationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } on UnauthorizedException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email or password',
      );
    } on NetworkException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error. Please check your connection.',
      );
    } on ServerException {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Server error. Please try again later.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
    }
  }

  /// Logout method
  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true);

      await _authRepository.logout();

      state = const AuthState(); // Reset to initial state
    } catch (e) {
      // Even if logout fails, reset local state
      state = const AuthState();
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

/// Auth state provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

// ============================================================================
// 🎯 CONVENIENT DERIVED PROVIDERS
// ============================================================================

/// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoggedIn;
});

/// Get current user
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

/// Check if auth is loading
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

/// Get auth error message
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).errorMessage;
});

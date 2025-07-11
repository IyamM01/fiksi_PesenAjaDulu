import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    // External dependencies
    await _initExternal();

    // Core dependencies
    await _initCore();

    // Initialize repositories
    // Initialize use cases
    // Initialize data sources
  }

  static Future<void> _initExternal() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton(() => sharedPreferences);
  }

  static Future<void> _initCore() async {
    // Initialize Dio client
    await DioClient.init();
    sl.registerLazySingleton<Dio>(() => DioClient.dio);
  }
}

// Example of how to structure dependencies:
/*
void _initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
}
*/

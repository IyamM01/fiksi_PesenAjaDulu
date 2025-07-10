import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User> call({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    return await repository.signUp(
      email: email,
      password: password,
      name: name,
      phoneNumber: phoneNumber,
    );
  }
}

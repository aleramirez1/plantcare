import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({required this.repository});

  Future<AuthEntity> execute(String email, String password) async {
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email invalido');
    }
    
    if (password.isEmpty || password.length < 6) {
      throw Exception('Contraseña debe tener al menos 6 caracteres');
    }

    return await repository.login(email, password);
  }
}

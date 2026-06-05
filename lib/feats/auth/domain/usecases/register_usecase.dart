import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase({required this.repository});

  Future<AuthEntity> execute(String email, String password, String nombre) async {
    if (email.isEmpty || !email.contains('@')) {
      throw Exception('Email invalido');
    }
    
    if (password.isEmpty || password.length < 6) {
      throw Exception('Contraseña debe tener al menos 6 caracteres');
    }

    if (nombre.isEmpty) {
      throw Exception('Nombre requerido');
    }

    return await repository.register(email, password, nombre);
  }
}

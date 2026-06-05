import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<AuthEntity> login(String email, String password) async {
    return await remoteDatasource.login(email, password);
  }

  @override
  Future<AuthEntity> register(String email, String password, String nombre) async {
    return await remoteDatasource.register(email, password, nombre);
  }
}

import '../../models/auth_model.dart';

abstract class AuthRemoteDatasource {
  Future<AuthModel> login(String email, String password);
  Future<AuthModel> register(String email, String password, String nombre);
}

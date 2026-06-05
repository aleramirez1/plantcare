import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth_model.dart';
import 'auth_remote_datasource.dart';
import 'constants/auth_remote_constants.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final http.Client client;

  AuthRemoteDatasourceImpl({required this.client});

  @override
  Future<AuthModel> login(String email, String password) async {
    try {
      print('LOGIN - URL: ${AuthRemoteConstants.loginEndpoint}');
      
      final response = await client
          .post(
            Uri.parse(AuthRemoteConstants.loginEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('LOGIN - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al iniciar sesion');
      }
    } catch (e) {
      print('LOGIN - Error: $e');
      throw Exception('No se pudo conectar al servidor');
    }
  }

  @override
  Future<AuthModel> register(String email, String password, String nombre) async {
    try {
      print('REGISTER - URL: ${AuthRemoteConstants.registerEndpoint}');
      
      final response = await client
          .post(
            Uri.parse(AuthRemoteConstants.registerEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'name': nombre,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('REGISTER - Status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AuthModel.fromJson(data);
      } else {
        final error = jsonDecode(response.body);
        throw Exception(error['detail'] ?? 'Error al registrar');
      }
    } catch (e) {
      print('REGISTER - Error: $e');
      throw Exception('No se pudo conectar al servidor');
    }
  }
}

import 'package:flutter/material.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthViewmodel extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  final RegisterUsecase registerUsecase;

  AuthViewmodel({
    required this.loginUsecase,
    required this.registerUsecase,
  });

  AuthEntity? _usuario;
  bool _isLoading = false;
  String? _error;

  AuthEntity? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _usuario != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await loginUsecase.execute(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String email, String password, String nombre) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await registerUsecase.execute(email, password, nombre);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}

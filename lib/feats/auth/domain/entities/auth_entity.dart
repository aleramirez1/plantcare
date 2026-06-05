class AuthEntity {
  final String id;
  final String email;
  final String nombre;
  final String? token;

  AuthEntity({
    required this.id,
    required this.email,
    required this.nombre,
    this.token,
  });
}

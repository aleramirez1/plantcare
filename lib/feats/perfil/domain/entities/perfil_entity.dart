class PerfilEntity {
  final String nombre;
  final String email;
  final int totalPlantas;
  final int plantasSanas;
  final int plantasNecesitanRiego;

  PerfilEntity({
    required this.nombre,
    required this.email,
    required this.totalPlantas,
    required this.plantasSanas,
    required this.plantasNecesitanRiego,
  });
}

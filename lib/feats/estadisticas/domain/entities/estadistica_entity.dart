class EstadisticaEntity {
  final int plantasSanas;
  final int plantasRegulares;
  final int plantasMalas;
  final Map<String, int> plantasPorTipo;

  EstadisticaEntity({
    required this.plantasSanas,
    required this.plantasRegulares,
    required this.plantasMalas,
    required this.plantasPorTipo,
  });
}

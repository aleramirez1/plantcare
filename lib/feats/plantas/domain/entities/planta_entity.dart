class PlantaEntity {
  final String id;
  final String nombre;
  final String especie;
  final DateTime fechaSiembra;
  final String tipo;
  final int frecuenciaRiego;
  final DateTime? ultimoRiego;
  final String estadoSalud;
  final String ubicacion;
  final String? foto;

  PlantaEntity({
    required this.id,
    required this.nombre,
    required this.especie,
    required this.fechaSiembra,
    required this.tipo,
    required this.frecuenciaRiego,
    this.ultimoRiego,
    required this.estadoSalud,
    required this.ubicacion,
    this.foto,
  });

  bool get necesitaRiego {
    if (ultimoRiego == null) return true;
    
    final ahora = DateTime.now();
    final ultimoRiegoSinHora = DateTime(ultimoRiego!.year, ultimoRiego!.month, ultimoRiego!.day);
    final ahoraSinHora = DateTime(ahora.year, ahora.month, ahora.day);
    final diasDesdeRiego = ahoraSinHora.difference(ultimoRiegoSinHora).inDays;
    
    return diasDesdeRiego >= frecuenciaRiego;
  }

  int get diasHastaRiego {
    if (ultimoRiego == null) return 0;
    
    final ahora = DateTime.now();
    final ultimoRiegoSinHora = DateTime(ultimoRiego!.year, ultimoRiego!.month, ultimoRiego!.day);
    final ahoraSinHora = DateTime(ahora.year, ahora.month, ahora.day);
    final diasDesdeRiego = ahoraSinHora.difference(ultimoRiegoSinHora).inDays;
    final diasRestantes = frecuenciaRiego - diasDesdeRiego;
    
    return diasRestantes > 0 ? diasRestantes : 0;
  }
}

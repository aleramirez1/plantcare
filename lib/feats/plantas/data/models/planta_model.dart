import '../../domain/entities/planta_entity.dart';

class PlantaModel extends PlantaEntity {
  PlantaModel({
    required super.id,
    required super.nombre,
    required super.especie,
    required super.fechaSiembra,
    required super.tipo,
    required super.frecuenciaRiego,
    super.ultimoRiego,
    required super.estadoSalud,
    required super.ubicacion,
    super.foto,
  });

  factory PlantaModel.fromJson(Map<String, dynamic> json) {
    return PlantaModel(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre'] ?? '',
      especie: json['especie'] ?? '',
      fechaSiembra: DateTime.parse(json['fechaSiembra'] ?? DateTime.now().toIso8601String()),
      tipo: json['tipo'] ?? '',
      frecuenciaRiego: json['frecuenciaRiego'] ?? 7,
      ultimoRiego: json['ultimoRiego'] != null ? DateTime.parse(json['ultimoRiego']) : null,
      estadoSalud: json['estadoSalud'] ?? 'bueno',
      ubicacion: json['ubicacion'] ?? '',
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'especie': especie,
      'fechaSiembra': fechaSiembra.toIso8601String(),
      'tipo': tipo,
      'frecuenciaRiego': frecuenciaRiego,
      'ultimoRiego': ultimoRiego?.toIso8601String(),
      'estadoSalud': estadoSalud,
      'ubicacion': ubicacion,
      'foto': foto,
    };
  }

  Map<String, dynamic> toJsonWithId() {
    return {
      'id': id,
      'nombre': nombre,
      'especie': especie,
      'fechaSiembra': fechaSiembra.toIso8601String(),
      'tipo': tipo,
      'frecuenciaRiego': frecuenciaRiego,
      'ultimoRiego': ultimoRiego?.toIso8601String(),
      'estadoSalud': estadoSalud,
      'ubicacion': ubicacion,
      'foto': foto,
    };
  }
}

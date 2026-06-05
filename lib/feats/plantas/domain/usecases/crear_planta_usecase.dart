import '../entities/planta_entity.dart';
import '../repositories/plantas_repository.dart';

class CrearPlantaUsecase {
  final PlantasRepository repository;

  CrearPlantaUsecase({required this.repository});

  Future<PlantaEntity> execute(PlantaEntity planta) async {
    if (planta.nombre.isEmpty) {
      throw Exception('El nombre es requerido');
    }
    
    if (planta.especie.isEmpty) {
      throw Exception('La especie es requerida');
    }
    
    if (planta.frecuenciaRiego <= 0) {
      throw Exception('La frecuencia de riego debe ser mayor a 0');
    }

    return await repository.crearPlanta(planta);
  }
}

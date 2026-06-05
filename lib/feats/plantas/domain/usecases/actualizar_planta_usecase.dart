import '../entities/planta_entity.dart';
import '../repositories/plantas_repository.dart';

class ActualizarPlantaUsecase {
  final PlantasRepository repository;

  ActualizarPlantaUsecase({required this.repository});

  Future<PlantaEntity> execute(PlantaEntity planta) async {
    if (planta.id.isEmpty) {
      throw Exception('ID invalido');
    }
    
    if (planta.nombre.isEmpty) {
      throw Exception('El nombre es requerido');
    }

    return await repository.actualizarPlanta(planta);
  }
}

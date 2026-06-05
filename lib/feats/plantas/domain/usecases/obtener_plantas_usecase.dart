import '../entities/planta_entity.dart';
import '../repositories/plantas_repository.dart';

class ObtenerPlantasUsecase {
  final PlantasRepository repository;

  ObtenerPlantasUsecase({required this.repository});

  Future<List<PlantaEntity>> execute() async {
    return await repository.obtenerPlantas();
  }
}

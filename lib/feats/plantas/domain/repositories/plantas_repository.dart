import '../entities/planta_entity.dart';

abstract class PlantasRepository {
  Future<List<PlantaEntity>> obtenerPlantas();
  Future<PlantaEntity> crearPlanta(PlantaEntity planta);
  Future<PlantaEntity> actualizarPlanta(PlantaEntity planta);
  Future<void> eliminarPlanta(String id);
}

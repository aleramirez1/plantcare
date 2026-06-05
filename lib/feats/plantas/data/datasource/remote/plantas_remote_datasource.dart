import '../../models/planta_model.dart';

abstract class PlantasRemoteDatasource {
  Future<List<PlantaModel>> obtenerPlantas();
  Future<PlantaModel> crearPlanta(PlantaModel planta);
  Future<PlantaModel> actualizarPlanta(PlantaModel planta);
  Future<void> eliminarPlanta(String id);
}

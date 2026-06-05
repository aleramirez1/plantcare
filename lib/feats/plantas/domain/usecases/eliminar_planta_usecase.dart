import '../repositories/plantas_repository.dart';

class EliminarPlantaUsecase {
  final PlantasRepository repository;

  EliminarPlantaUsecase({required this.repository});

  Future<void> execute(String id) async {
    if (id.isEmpty) {
      throw Exception('ID invalido');
    }

    return await repository.eliminarPlanta(id);
  }
}

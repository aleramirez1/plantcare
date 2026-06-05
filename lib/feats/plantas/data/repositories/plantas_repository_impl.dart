import '../../domain/entities/planta_entity.dart';
import '../../domain/repositories/plantas_repository.dart';
import '../datasource/remote/plantas_remote_datasource.dart';
import '../models/planta_model.dart';

class PlantasRepositoryImpl implements PlantasRepository {
  final PlantasRemoteDatasource remoteDatasource;

  PlantasRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<PlantaEntity>> obtenerPlantas() async {
    return await remoteDatasource.obtenerPlantas();
  }

  @override
  Future<PlantaEntity> crearPlanta(PlantaEntity planta) async {
    final plantaModel = PlantaModel(
      id: planta.id,
      nombre: planta.nombre,
      especie: planta.especie,
      fechaSiembra: planta.fechaSiembra,
      tipo: planta.tipo,
      frecuenciaRiego: planta.frecuenciaRiego,
      ultimoRiego: planta.ultimoRiego,
      estadoSalud: planta.estadoSalud,
      ubicacion: planta.ubicacion,
      foto: planta.foto,
    );
    return await remoteDatasource.crearPlanta(plantaModel);
  }

  @override
  Future<PlantaEntity> actualizarPlanta(PlantaEntity planta) async {
    final plantaModel = PlantaModel(
      id: planta.id,
      nombre: planta.nombre,
      especie: planta.especie,
      fechaSiembra: planta.fechaSiembra,
      tipo: planta.tipo,
      frecuenciaRiego: planta.frecuenciaRiego,
      ultimoRiego: planta.ultimoRiego,
      estadoSalud: planta.estadoSalud,
      ubicacion: planta.ubicacion,
      foto: planta.foto,
    );
    return await remoteDatasource.actualizarPlanta(plantaModel);
  }

  @override
  Future<void> eliminarPlanta(String id) async {
    return await remoteDatasource.eliminarPlanta(id);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/planta_model.dart';
import 'plantas_remote_datasource.dart';
import 'constants/plantas_remote_constants.dart';

class PlantasRemoteDatasourceImpl implements PlantasRemoteDatasource {
  final http.Client client;

  PlantasRemoteDatasourceImpl({required this.client});

  @override
  Future<List<PlantaModel>> obtenerPlantas() async {
    try {
      final response = await client
          .get(
            Uri.parse(PlantasRemoteConstants.plantasEndpoint),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PlantaModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener plantas');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor');
    }
  }

  @override
  Future<PlantaModel> crearPlanta(PlantaModel planta) async {
    try {
      final response = await client
          .post(
            Uri.parse(PlantasRemoteConstants.plantasEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(planta.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return PlantaModel.fromJson(data);
      } else {
        throw Exception('Error al crear planta');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor');
    }
  }

  @override
  Future<PlantaModel> actualizarPlanta(PlantaModel planta) async {
    try {
      final response = await client
          .put(
            Uri.parse('${PlantasRemoteConstants.plantasEndpoint}/${planta.id}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(planta.toJsonWithId()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PlantaModel.fromJson(data);
      } else {
        throw Exception('Error al actualizar planta');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor');
    }
  }

  @override
  Future<void> eliminarPlanta(String id) async {
    try {
      final response = await client
          .delete(
            Uri.parse('${PlantasRemoteConstants.plantasEndpoint}/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar planta');
      }
    } catch (e) {
      throw Exception('No se pudo conectar al servidor');
    }
  }
}

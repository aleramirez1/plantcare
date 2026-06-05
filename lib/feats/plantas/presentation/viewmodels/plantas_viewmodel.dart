import 'package:flutter/material.dart';
import '../../domain/entities/planta_entity.dart';
import '../../domain/usecases/obtener_plantas_usecase.dart';
import '../../domain/usecases/crear_planta_usecase.dart';
import '../../domain/usecases/actualizar_planta_usecase.dart';
import '../../domain/usecases/eliminar_planta_usecase.dart';

class PlantasViewmodel extends ChangeNotifier {
  final ObtenerPlantasUsecase obtenerPlantasUsecase;
  final CrearPlantaUsecase crearPlantaUsecase;
  final ActualizarPlantaUsecase actualizarPlantaUsecase;
  final EliminarPlantaUsecase eliminarPlantaUsecase;

  PlantasViewmodel({
    required this.obtenerPlantasUsecase,
    required this.crearPlantaUsecase,
    required this.actualizarPlantaUsecase,
    required this.eliminarPlantaUsecase,
  });

  List<PlantaEntity> _plantas = [];
  bool _isLoading = false;
  String? _error;

  List<PlantaEntity> get plantas => _plantas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarPlantas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plantas = await obtenerPlantasUsecase.execute();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _plantas = [];
      notifyListeners();
    }
  }

  Future<bool> agregarPlanta(PlantaEntity planta) async {
    try {
      final nuevaPlanta = await crearPlantaUsecase.execute(planta);
      _plantas.add(nuevaPlanta);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarPlanta(PlantaEntity planta) async {
    try {
      final plantaActualizada = await actualizarPlantaUsecase.execute(planta);
      final index = _plantas.indexWhere((p) => p.id == planta.id);
      if (index != -1) {
        _plantas[index] = plantaActualizada;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarPlanta(String id) async {
    try {
      await eliminarPlantaUsecase.execute(id);
      _plantas.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}

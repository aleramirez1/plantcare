import 'package:http/http.dart' as http;
import '../feats/auth/data/datasource/remote/auth_remote_datasource_impl.dart';
import '../feats/auth/data/repositories/auth_repository_impl.dart';
import '../feats/auth/domain/usecases/login_usecase.dart';
import '../feats/auth/domain/usecases/register_usecase.dart';
import '../feats/auth/presentation/viewmodels/auth_viewmodel.dart';

import '../feats/plantas/data/datasource/remote/plantas_remote_datasource_impl.dart';
import '../feats/plantas/data/repositories/plantas_repository_impl.dart';
import '../feats/plantas/domain/usecases/crear_planta_usecase.dart';
import '../feats/plantas/domain/usecases/obtener_plantas_usecase.dart';
import '../feats/plantas/domain/usecases/actualizar_planta_usecase.dart';
import '../feats/plantas/domain/usecases/eliminar_planta_usecase.dart';
import '../feats/plantas/presentation/viewmodels/plantas_viewmodel.dart';

class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  late http.Client _httpClient;
  late AuthViewmodel _authViewmodel;
  late PlantasViewmodel _plantasViewmodel;

  void init() {
    _httpClient = http.Client();
    _initAuth();
    _initPlantas();
  }

  void _initAuth() {
    final datasource = AuthRemoteDatasourceImpl(client: _httpClient);
    final repository = AuthRepositoryImpl(remoteDatasource: datasource);
    final loginUsecase = LoginUsecase(repository: repository);
    final registerUsecase = RegisterUsecase(repository: repository);
    _authViewmodel = AuthViewmodel(
      loginUsecase: loginUsecase,
      registerUsecase: registerUsecase,
    );
  }

  void _initPlantas() {
    final datasource = PlantasRemoteDatasourceImpl(client: _httpClient);
    final repository = PlantasRepositoryImpl(remoteDatasource: datasource);
    final obtenerUsecase = ObtenerPlantasUsecase(repository: repository);
    final crearUsecase = CrearPlantaUsecase(repository: repository);
    final actualizarUsecase = ActualizarPlantaUsecase(repository: repository);
    final eliminarUsecase = EliminarPlantaUsecase(repository: repository);
    _plantasViewmodel = PlantasViewmodel(
      obtenerPlantasUsecase: obtenerUsecase,
      crearPlantaUsecase: crearUsecase,
      actualizarPlantaUsecase: actualizarUsecase,
      eliminarPlantaUsecase: eliminarUsecase,
    );
  }

  AuthViewmodel get authViewmodel => _authViewmodel;
  PlantasViewmodel get plantasViewmodel => _plantasViewmodel;

  void dispose() {
    _httpClient.close();
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../plantas/presentation/viewmodels/plantas_viewmodel.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/perfil_info_card_widget.dart';
import '../widgets/perfil_stats_card_widget.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewmodel = context.watch<AuthViewmodel>();
    final plantasViewmodel = context.watch<PlantasViewmodel>();
    
    final usuario = authViewmodel.usuario;
    final totalPlantas = plantasViewmodel.plantas.length;
    final plantasSanas = plantasViewmodel.plantas.where((p) => p.estadoSalud == 'bueno').length;
    final plantasNecesitanAgua = plantasViewmodel.plantas.where((p) => p.necesitaRiego).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PerfilInfoCardWidget(
              nombre: usuario?.nombre ?? 'Usuario',
              email: usuario?.email ?? '',
            ),
            const SizedBox(height: 16),
            PerfilStatsCardWidget(
              totalPlantas: totalPlantas,
              plantasSanas: plantasSanas,
              plantasNecesitanRiego: plantasNecesitanAgua,
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Cerrar sesion'),
                onTap: () {
                  authViewmodel.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

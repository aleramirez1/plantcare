import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../plantas/presentation/viewmodels/plantas_viewmodel.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../widgets/dashboard_header_widget.dart';
import '../widgets/filtro_chip_widget.dart';
import '../widgets/planta_card_widget.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _filtro = 'Todas';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlantasViewmodel>().cargarPlantas();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> _filtrarPlantas(List plantas) {
    var filtered = plantas;
    if (_filtro == 'Sanas') {
      filtered = plantas.where((p) => p.estadoSalud == 'bueno').toList();
    } else if (_filtro == 'Agua') {
      filtered = plantas.where((p) => p.necesitaRiego).toList();
    }
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((p) => p.nombre.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final userName = context.watch<AuthViewmodel>().usuario?.nombre ?? 'Usuario';
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Buenos dias' : now.hour < 18 ? 'Buenas tardes' : 'Buenas noches';
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Consumer<PlantasViewmodel>(
          builder: (context, plantasViewmodel, _) {
            if (plantasViewmodel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (plantasViewmodel.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${plantasViewmodel.error}'),
                    ElevatedButton(
                      onPressed: () => plantasViewmodel.cargarPlantas(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            final plantas = plantasViewmodel.plantas;
            final plantasFiltradas = _filtrarPlantas(plantas);
            final plantasNecesitanRiego = plantas.where((p) => p.necesitaRiego).length;

            return Column(
              children: [
                DashboardHeaderWidget(
                  greeting: greeting,
                  userName: userName,
                ),
                
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Buscar planta...',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                            ),
                            onChanged: (value) => setState(() {}),
                          ),
                        ),
                      ),
                      
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                FiltroChipWidget(
                                  label: 'Todas',
                                  icon: Icons.grid_view,
                                  selected: _filtro == 'Todas',
                                  onTap: () => setState(() => _filtro = 'Todas'),
                                ),
                                const SizedBox(width: 8),
                                FiltroChipWidget(
                                  label: 'Sanas',
                                  icon: Icons.eco,
                                  selected: _filtro == 'Sanas',
                                  onTap: () => setState(() => _filtro = 'Sanas'),
                                ),
                                const SizedBox(width: 8),
                                FiltroChipWidget(
                                  label: 'Necesitan agua',
                                  icon: Icons.water_drop,
                                  count: plantasNecesitanRiego,
                                  selected: _filtro == 'Agua',
                                  onTap: () => setState(() => _filtro = 'Agua'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => PlantaCardWidget(planta: plantasFiltradas[index]),
                            childCount: plantasFiltradas.length,
                          ),
                        ),
                      ),
                      
                      const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

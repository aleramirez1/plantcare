import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../plantas/presentation/viewmodels/plantas_viewmodel.dart';
import '../widgets/stat_card_widget.dart';

class EstadisticasPage extends StatelessWidget {
  const EstadisticasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadisticas'),
        centerTitle: true,
      ),
      body: Consumer<PlantasViewmodel>(
        builder: (context, plantasViewmodel, _) {
          if (plantasViewmodel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (plantasViewmodel.plantas.isEmpty) {
            return const Center(child: Text('No hay plantas para mostrar estadisticas'));
          }

          final plantas = plantasViewmodel.plantas;
          final totalPlantas = plantas.length;
          final plantasSanas = plantas.where((p) => p.estadoSalud == 'bueno').length;
          final plantasRegulares = plantas.where((p) => p.estadoSalud == 'regular').length;
          final plantasMalas = plantas.where((p) => p.estadoSalud == 'malo').length;

          final Map<String, int> tiposPlantas = {};
          for (var planta in plantas) {
            tiposPlantas[planta.tipo] = (tiposPlantas[planta.tipo] ?? 0) + 1;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen general',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StatCardWidget(
                              title: 'Total',
                              value: totalPlantas.toString(),
                              icon: Icons.yard,
                              color: Colors.green,
                            ),
                            StatCardWidget(
                              title: 'Sanas',
                              value: plantasSanas.toString(),
                              icon: Icons.favorite,
                              color: Colors.green,
                            ),
                            StatCardWidget(
                              title: 'Regulares',
                              value: plantasRegulares.toString(),
                              icon: Icons.warning,
                              color: Colors.orange,
                            ),
                            StatCardWidget(
                              title: 'Malas',
                              value: plantasMalas.toString(),
                              icon: Icons.cancel,
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Estado de salud',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: plantasSanas.toDouble(),
                              title: '$plantasSanas',
                              color: Colors.green,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: plantasRegulares.toDouble(),
                              title: '$plantasRegulares',
                              color: Colors.orange,
                              radius: 50,
                            ),
                            PieChartSectionData(
                              value: plantasMalas.toDouble(),
                              title: '$plantasMalas',
                              color: Colors.red,
                              radius: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tipos de plantas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      height: 250,
                      child: BarChart(
                        BarChartData(
                          barGroups: tiposPlantas.entries.map((entry) {
                            final index = tiposPlantas.keys.toList().indexOf(entry.key);
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.toDouble(),
                                  color: Colors.green[800],
                                  width: 20,
                                ),
                              ],
                            );
                          }).toList(),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index >= 0 && index < tiposPlantas.length) {
                                    return Text(
                                      tiposPlantas.keys.toList()[index],
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

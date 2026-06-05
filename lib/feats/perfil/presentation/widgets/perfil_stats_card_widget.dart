import 'package:flutter/material.dart';

class PerfilStatsCardWidget extends StatelessWidget {
  final int totalPlantas;
  final int plantasSanas;
  final int plantasNecesitanRiego;

  const PerfilStatsCardWidget({
    super.key,
    required this.totalPlantas,
    required this.plantasSanas,
    required this.plantasNecesitanRiego,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.yard),
            title: const Text('Total de plantas'),
            trailing: Text(
              totalPlantas.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.favorite, color: Colors.green),
            title: const Text('Plantas sanas'),
            trailing: Text(
              plantasSanas.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.water_drop, color: Colors.blue),
            title: const Text('Necesitan riego'),
            trailing: Text(
              plantasNecesitanRiego.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/planta_entity.dart';

class PlantaInfoCardWidget extends StatelessWidget {
  final PlantaEntity planta;

  const PlantaInfoCardWidget({
    super.key,
    required this.planta,
  });

  @override
  Widget build(BuildContext context) {
    final necesitaRiego = planta.necesitaRiego;
    final diasHasta = planta.diasHastaRiego;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.category, color: Colors.green[800]),
              title: const Text('Tipo'),
              subtitle: Text(planta.tipo),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.calendar_today, color: Colors.green[800]),
              title: const Text('Fecha de siembra'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(planta.fechaSiembra)),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.water_drop, color: Colors.blue[800]),
              title: const Text('Frecuencia de riego'),
              subtitle: Text('Cada ${planta.frecuenciaRiego} dias'),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.schedule, color: Colors.blue[800]),
              title: const Text('Ultimo riego'),
              subtitle: Text(
                planta.ultimoRiego != null
                    ? DateFormat('dd/MM/yyyy').format(planta.ultimoRiego!)
                    : 'No registrado',
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                necesitaRiego ? Icons.warning_amber : Icons.check_circle,
                color: necesitaRiego ? Colors.orange : Colors.green,
              ),
              title: const Text('Estado'),
              subtitle: Text(
                necesitaRiego ? 'Necesita riego' : 'Regar en $diasHasta dias',
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.red[400]),
              title: const Text('Salud'),
              subtitle: Text(planta.estadoSalud),
            ),
          ],
        ),
      ),
    );
  }
}

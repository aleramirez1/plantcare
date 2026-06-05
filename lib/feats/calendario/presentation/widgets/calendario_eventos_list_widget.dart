import 'package:flutter/material.dart';

class CalendarioEventosListWidget extends StatelessWidget {
  final List<String> plantasDelDia;

  const CalendarioEventosListWidget({
    super.key,
    required this.plantasDelDia,
  });

  @override
  Widget build(BuildContext context) {
    if (plantasDelDia.isEmpty) {
      return const Center(child: Text('No hay riegos programados'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plantasDelDia.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.water_drop, color: Colors.blue),
            title: Text(plantasDelDia[index]),
            subtitle: const Text('Dia de riego'),
          ),
        );
      },
    );
  }
}

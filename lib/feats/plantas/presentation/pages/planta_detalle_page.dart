import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/planta_entity.dart';
import '../viewmodels/plantas_viewmodel.dart';
import 'planta_formulario_page.dart';
import '../widgets/planta_info_card_widget.dart';

class PlantaDetallePage extends StatelessWidget {
  final PlantaEntity planta;

  const PlantaDetallePage({super.key, required this.planta});

  @override
  Widget build(BuildContext context) {
    final diasHasta = planta.diasHastaRiego;
    final necesitaRiego = planta.necesitaRiego;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: planta.foto != null && planta.foto!.isNotEmpty && File(planta.foto!).existsSync()
                  ? Image.file(File(planta.foto!), fit: BoxFit.cover)
                  : Container(
                      color: Colors.green[200],
                      child: const Icon(Icons.local_florist, size: 120, color: Colors.white),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlantaFormularioPage(planta: planta),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Eliminar planta'),
                      content: const Text('¿Estas seguro de eliminar esta planta?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    await context.read<PlantasViewmodel>().eliminarPlanta(planta.id);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planta.nombre,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    planta.especie,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  PlantaInfoCardWidget(planta: planta),
                  const SizedBox(height: 16),
                  if (necesitaRiego)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.water_drop),
                        label: const Text('Regar ahora'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          final plantaActualizada = PlantaEntity(
                            id: planta.id,
                            nombre: planta.nombre,
                            especie: planta.especie,
                            fechaSiembra: planta.fechaSiembra,
                            tipo: planta.tipo,
                            frecuenciaRiego: planta.frecuenciaRiego,
                            ultimoRiego: DateTime.now(),
                            estadoSalud: planta.estadoSalud,
                            ubicacion: planta.ubicacion,
                            foto: planta.foto,
                          );

                          final success = await context.read<PlantasViewmodel>().actualizarPlanta(plantaActualizada);
                          
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Planta regada exitosamente')),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

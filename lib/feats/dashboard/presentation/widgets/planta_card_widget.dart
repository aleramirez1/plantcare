import 'dart:io';
import 'package:flutter/material.dart';

class PlantaCardWidget extends StatelessWidget {
  final dynamic planta;
  final VoidCallback onTap;

  const PlantaCardWidget({
    super.key,
    required this.planta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool tieneImagen = false;
    if (planta.foto != null && planta.foto!.isNotEmpty) {
      try {
        tieneImagen = File(planta.foto!).existsSync();
      } catch (e) {
        tieneImagen = false;
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: planta.necesitaRiego
                      ? Colors.orange[100]
                      : Colors.green[100],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  image: tieneImagen
                      ? DecorationImage(
                          image: FileImage(File(planta.foto!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: !tieneImagen
                    ? Center(
                        child: Icon(
                          Icons.local_florist,
                          size: 64,
                          color: planta.necesitaRiego
                              ? Colors.orange[300]
                              : Colors.green[300],
                        ),
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planta.nombre,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${planta.tipo}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hidratacion',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: planta.necesitaRiego ? 0.3 : 0.8,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation(
                          planta.necesitaRiego ? Colors.orange : Colors.green,
                        ),
                        minHeight: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: planta.necesitaRiego
                          ? Colors.orange[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          planta.necesitaRiego
                              ? Icons.warning_amber
                              : Icons.check_circle,
                          size: 12,
                          color: planta.necesitaRiego
                              ? Colors.orange
                              : Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          planta.necesitaRiego ? 'Regar' : 'Sana',
                          style: TextStyle(
                            color: planta.necesitaRiego
                                ? Colors.orange[700]
                                : Colors.green[700],
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

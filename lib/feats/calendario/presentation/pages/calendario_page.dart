import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../plantas/presentation/viewmodels/plantas_viewmodel.dart';
import '../widgets/calendario_eventos_list_widget.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  State<CalendarioPage> createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Map<DateTime, List<String>> _getEventos(List plantas) {
    final Map<DateTime, List<String>> eventos = {};
    
    for (var planta in plantas) {
      if (planta.ultimoRiego != null) {
        DateTime siguienteRiego = planta.ultimoRiego!.add(Duration(days: planta.frecuenciaRiego));
        
        while (siguienteRiego.isBefore(DateTime.now().add(const Duration(days: 30)))) {
          final fecha = DateTime(siguienteRiego.year, siguienteRiego.month, siguienteRiego.day);
          
          if (eventos[fecha] == null) {
            eventos[fecha] = [];
          }
          eventos[fecha]!.add(planta.nombre);
          
          siguienteRiego = siguienteRiego.add(Duration(days: planta.frecuenciaRiego));
        }
      }
    }
    
    return eventos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de riego'),
        centerTitle: true,
      ),
      body: Consumer<PlantasViewmodel>(
        builder: (context, plantasViewmodel, _) {
          if (plantasViewmodel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventos = _getEventos(plantasViewmodel.plantas);

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 365)),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.green[300],
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green[800],
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                eventLoader: (day) {
                  final fecha = DateTime(day.year, day.month, day.day);
                  return eventos[fecha] ?? [];
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
              const Divider(height: 1),
              Expanded(
                child: CalendarioEventosListWidget(
                  plantasDelDia: _selectedDay != null
                      ? eventos[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? []
                      : [],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

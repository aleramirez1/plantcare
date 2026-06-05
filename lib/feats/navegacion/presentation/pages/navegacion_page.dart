import 'package:flutter/material.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../calendario/presentation/pages/calendario_page.dart';
import '../../../estadisticas/presentation/pages/estadisticas_page.dart';
import '../../../perfil/presentation/pages/perfil_page.dart';
import '../../../plantas/presentation/pages/planta_formulario_page.dart';

class NavegacionPage extends StatefulWidget {
  const NavegacionPage({super.key});

  @override
  State<NavegacionPage> createState() => _NavegacionPageState();
}

class _NavegacionPageState extends State<NavegacionPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const CalendarioPage(),
    const EstadisticasPage(),
    const PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PlantaFormularioPage()),
          );
        },
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.eco, 0),
            _buildNavItem(Icons.calendar_today, 1),
            const SizedBox(width: 40),
            _buildNavItem(Icons.bar_chart, 2),
            _buildNavItem(Icons.person_outline, 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return IconButton(
      icon: Icon(
        icon,
        color: isSelected ? Colors.green[800] : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'title': 'PROPUESTAS DE REMATE', 'expanded': false, 'children': ['LISTADO', 'HISTORIAL'], 'routes': ['', '']},
    {'title': 'RESERVA DE CITA', 'expanded': false, 'children': ['LISTADO'], 'routes': ['/listado-citas']},
    {'title': 'ADJUDICADO', 'expanded': false, 'children': ['DOCUMENTOS', 'INSPECCION', 'ESTADO DE ADJUDICADO', 'LISTADO', 'SEGURO'], 'routes': ['', '', '', '', '']},
    {'title': 'CONTRATOS', 'expanded': false, 'children': ['LISTADO'], 'routes': ['']},
  ];

  Widget _buildHome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Inicio', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                _buildCard('Propuestas disponibles', Icons.assignment_outlined, const Color(0xFF4CAF50)),
                const SizedBox(height: 12),
                _buildCard('Propuestas rematadas', Icons.history, const Color(0xFF26A69A)),
                const SizedBox(height: 12),
                _buildCard('Citas pendientes', Icons.calendar_today, const Color(0xFFEF5350)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('0', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
          const Spacer(),
          Icon(icon, color: Colors.white.withValues(alpha: 0.3), size: 64),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Menu', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              final isExpanded = item['expanded'] as bool;
              final children = item['children'] as List<String>;
              final routes = item['routes'] as List<String>;
              return Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        for (int i = 0; i < _menuItems.length; i++) {
                          if (i != index) _menuItems[i]['expanded'] = false;
                        }
                        _menuItems[index]['expanded'] = !isExpanded;
                      });
                    },
                    child: Container(
                      color: isExpanded ? const Color(0xFF26A69A) : Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Icon(
                            isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                            color: Colors.white, size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    ...List.generate(children.length, (i) => InkWell(
                      onTap: () {
                        final route = routes[i];
                        if (route.isNotEmpty) {
                          Navigator.of(context).pushNamed(route);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        child: Text(
                          children[i],
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                        ),
                      ),
                    )),
                  Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2332),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2332),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(text: 'Fon', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF003087))),
                TextSpan(text: 'bienes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1CB0F6))),
              ],
            ),
          ),
        ),
        leadingWidth: 120,
        actions: [
          const Icon(Icons.circle, color: Color(0xFF4CAF50), size: 10),
          const SizedBox(width: 4),
          const Text('EN LINEA', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
          const SizedBox(width: 16),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHome() : _buildMenu(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F1923),
        selectedItemColor: const Color(0xFF26A69A),
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context).pushReplacementNamed('/login');
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
      ),
    );
  }
}

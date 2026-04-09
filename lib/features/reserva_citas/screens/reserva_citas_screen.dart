import 'package:flutter/material.dart';
import 'package:autoatencion_app/shared/widgets/ax_button.dart';
import 'package:autoatencion_app/shared/widgets/ax_fonbienes_logo.dart';
import 'package:autoatencion_app/features/reserva_citas/models/cita_model.dart';
import 'package:autoatencion_app/features/reserva_citas/providers/citas_provider.dart';

class ReservaCitasScreen extends StatefulWidget {
  const ReservaCitasScreen({super.key});
  @override
  State<ReservaCitasScreen> createState() => _ReservaCitasScreenState();
}

class _ReservaCitasScreenState extends State<ReservaCitasScreen> {
  int _step = 0;
  String _selectedOficina = '';
  String _selectedArea = '';
  String _selectedMotivo = '';
  String _selectedSala = '';
  String _selectedHora = '';
  String _selectedFecha = '';
  String _expandedSala = '';

  final List<String> _oficinas = ['Oficina La Victoria', 'Oficina Arequipa', 'Oficina del Sur'];

  final List<Map<String, dynamic>> _areas = [
    {'nombre': 'Area de Ventas', 'icon': Icons.point_of_sale_outlined, 'color': const Color(0xFF1CB0F6)},
    {'nombre': 'Area de Adjudicacion', 'icon': Icons.gavel_outlined, 'color': const Color(0xFF4CAF50)},
    {'nombre': 'Area de Revision Documentaria', 'icon': Icons.folder_outlined, 'color': const Color(0xFFFF9800)},
    {'nombre': 'Area Legal', 'icon': Icons.balance_outlined, 'color': const Color(0xFF9C27B0)},
  ];

  final List<String> _motivos = ['Consulta de contrato', 'Pago de cuota', 'Adjudicacion', 'Documentos', 'Otros'];

  final List<String> _salas = ['Sala A', 'Sala B', 'Sala C', 'Sala D', 'Sala E', 'Sala F'];

  final List<String> _horas = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00',
  ];

  final List<String> _stepTitles = [
    'Seleccionar oficina',
    'Seleccionar area',
    'Motivo de visita',
    'Seleccionar fecha',
    'Sala y horario',
    'Confirmar cita',
  ];

  void _onSiguiente() {
    if (_step < 5) {
      setState(() => _step++);
    } else {
      CitasProvider().agregarCita(CitaModel(
        oficina: _selectedOficina,
        area: _selectedArea,
        motivo: _selectedMotivo,
        fecha: _selectedFecha,
        hora: _selectedHora,
        sala: _selectedSala,
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cita reservada correctamente'), backgroundColor: Color(0xFF4CAF50)),
      );
      Navigator.of(context).pop();
    }
  }

  void _onRegresar() {
    if (_step > 0) setState(() => _step--);
    else Navigator.of(context).pop();
  }

  bool get _canContinue {
    switch (_step) {
      case 0: return _selectedOficina.isNotEmpty;
      case 1: return _selectedArea.isNotEmpty;
      case 2: return _selectedMotivo.isNotEmpty;
      case 3: return _selectedFecha.isNotEmpty;
      case 4: return _selectedSala.isNotEmpty && _selectedHora.isNotEmpty;
      default: return true;
    }
  }

  Widget _buildSelectCard({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1CB0F6).withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF1CB0F6) : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
        ),
        child: Row(children: [
          Icon(icon, color: isSelected ? const Color(0xFF1CB0F6) : Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? const Color(0xFF1CB0F6) : Colors.black))),
          if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1CB0F6), size: 20),
        ]),
      ),
    );
  }

  Widget _buildStep0() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Elige una oficina cercana a ti', style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 16),
      ..._oficinas.map((o) => _buildSelectCard(title: o, icon: Icons.location_on_outlined, isSelected: _selectedOficina == o, onTap: () => setState(() => _selectedOficina = o))),
    ]);
  }

  Widget _buildStep1() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Selecciona el area con la que deseas comunicarte', style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 16),
      ..._areas.map((area) {
        final nombre = area['nombre'] as String;
        final icon = area['icon'] as IconData;
        final color = area['color'] as Color;
        final isSelected = _selectedArea == nombre;
        return GestureDetector(
          onTap: () => setState(() => _selectedArea = nombre),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
            ),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(child: Text(nombre, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal, color: isSelected ? color : Colors.black))),
              if (isSelected) Icon(Icons.check_circle, color: color, size: 20),
            ]),
          ),
        );
      }),
    ]);
  }

  Widget _buildStep2() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Area: $_selectedArea', style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 12),
      const Text('Selecciona el motivo de tu visita', style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 12),
      ..._motivos.map((m) => _buildSelectCard(title: m, icon: Icons.description_outlined, isSelected: _selectedMotivo == m, onTap: () => setState(() => _selectedMotivo = m))),
    ]);
  }

  Widget _buildStep3() {
    final now = DateTime.now();
    final dias = List.generate(14, (i) => now.add(Duration(days: i + 1)));
    final diasSemana = ['Lun', 'Mar', 'Mie', 'Jue', 'Vie', 'Sab', 'Dom'];
    final meses = ['Ene','Feb','Mar','Abr','May','Jun','Jul','Ago','Sep','Oct','Nov','Dic'];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Selecciona una fecha disponible', style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 16),
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.85, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: dias.length,
        itemBuilder: (context, i) {
          final dia = dias[i];
          final label = '${diasSemana[dia.weekday - 1]} ${dia.day} ${meses[dia.month - 1]}';
          final isSelected = _selectedFecha == label;
          final isWeekend = dia.weekday == 6 || dia.weekday == 7;
          return GestureDetector(
            onTap: isWeekend ? null : () => setState(() => _selectedFecha = label),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1CB0F6) : isWeekend ? Colors.grey.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: isSelected ? const Color(0xFF1CB0F6) : Colors.grey.shade300),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(diasSemana[dia.weekday - 1], style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : isWeekend ? Colors.grey : Colors.grey.shade600)),
                Text('${dia.day}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : isWeekend ? Colors.grey : Colors.black)),
                Text(meses[dia.month - 1], style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : isWeekend ? Colors.grey : Colors.grey.shade600)),
              ]),
            ),
          );
        },
      ),
    ]);
  }

  Widget _buildStep4() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Fecha: $_selectedFecha', style: const TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 8),
      const Text('Selecciona una sala y elige tu horario', style: TextStyle(fontSize: 13, color: Colors.grey)),
      const SizedBox(height: 16),
      ..._salas.map((sala) {
        final isExpanded = _expandedSala == sala;
        final isSelectedSala = _selectedSala == sala;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelectedSala ? const Color(0xFF1CB0F6) : Colors.grey.shade300,
              width: isSelectedSala ? 1.5 : 1,
            ),
          ),
          child: Column(children: [
            // Cabecera sala
            InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              onTap: () => setState(() => _expandedSala = isExpanded ? '' : sala),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelectedSala ? const Color(0xFF1CB0F6).withValues(alpha: 0.15) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.meeting_room, color: isSelectedSala ? const Color(0xFF1CB0F6) : Colors.grey, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(sala, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: isSelectedSala ? const Color(0xFF1CB0F6) : Colors.black)),
                    Text('09:00 - 17:00', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ])),
                  if (isSelectedSala) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF1CB0F6), borderRadius: BorderRadius.circular(6)),
                      child: Text(_selectedHora, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
                ]),
              ),
            ),
            // Horarios expandidos
            if (isExpanded) ...[
              Divider(height: 1, color: Colors.grey.shade200),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Elige un horario para $sala:', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _horas.map((hora) {
                      final isSelectedHora = _selectedSala == sala && _selectedHora == hora;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedSala = sala;
                          _selectedHora = hora;
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelectedHora ? const Color(0xFF1CB0F6) : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isSelectedHora ? const Color(0xFF1CB0F6) : Colors.grey.shade300),
                          ),
                          child: Text(hora, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelectedHora ? Colors.white : Colors.black)),
                        ),
                      );
                    }).toList(),
                  ),
                ]),
              ),
            ],
          ]),
        );
      }),
    ]);
  }

  Widget _buildStep5() {
    return Column(children: [
      const Icon(Icons.check_circle_outline, color: Color(0xFF4CAF50), size: 64),
      const SizedBox(height: 16),
      const Text('Confirma tu cita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      const SizedBox(height: 24),
      _buildResumenRow(Icons.location_on_outlined, 'Oficina', _selectedOficina),
      _buildResumenRow(Icons.business_outlined, 'Area', _selectedArea),
      _buildResumenRow(Icons.description_outlined, 'Motivo', _selectedMotivo),
      _buildResumenRow(Icons.calendar_today, 'Fecha', _selectedFecha),
      _buildResumenRow(Icons.meeting_room_outlined, 'Sala', _selectedSala),
      _buildResumenRow(Icons.access_time, 'Hora', _selectedHora),
    ]);
  }

  Widget _buildResumenRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF1CB0F6), size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ])),
      ]),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0: return _buildStep0();
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildStep4();
      case 5: return _buildStep5();
      default: return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18), onPressed: _onRegresar),
        title: const AxFonbienesLogo(),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _step ? 22 : 8, height: 8,
              decoration: BoxDecoration(
                color: i < _step ? const Color(0xFF4CAF50) : i == _step ? const Color(0xFF1CB0F6) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ))),
            const SizedBox(height: 8),
            Text('Paso ${_step + 1} de 6 — ${_stepTitles[_step]}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ]),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: KeyedSubtree(key: ValueKey(_step), child: _buildStepContent()),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: AxButton(label: _step == 5 ? 'Confirmar' : 'Siguiente', icon: Icons.arrow_forward_ios_rounded, variant: AxButtonVariant.secondary, onPressed: _canContinue ? _onSiguiente : null)),
            const SizedBox(width: 12),
            Expanded(child: AxButton(label: 'Regresar', icon: Icons.arrow_back_ios_rounded, onPressed: _onRegresar)),
          ]),
        ),
      ]),
    );
  }
}

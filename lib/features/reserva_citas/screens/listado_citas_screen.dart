import 'package:flutter/material.dart';
import 'package:autoatencion_app/features/reserva_citas/providers/citas_provider.dart';
import 'package:autoatencion_app/shared/widgets/ax_fonbienes_logo.dart';

class ListadoCitasScreen extends StatefulWidget {
  const ListadoCitasScreen({super.key});
  @override
  State<ListadoCitasScreen> createState() => _ListadoCitasScreenState();
}

class _ListadoCitasScreenState extends State<ListadoCitasScreen> {
  @override
  Widget build(BuildContext context) {
    final citas = CitasProvider().citas;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 18), onPressed: () => Navigator.of(context).pop()),
        title: const AxFonbienesLogo(),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Icon(Icons.calendar_today, color: Color(0xFF1CB0F6)),
            const SizedBox(width: 8),
            const Text('Mis Citas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFEF5350), borderRadius: BorderRadius.circular(12)),
              child: Text('${citas.length} cita(s)', style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ]),
        ),
        Expanded(
          child: citas.isEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.calendar_today_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No tienes citas registradas', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text('Reserva una cita desde el menu', style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: citas.length,
                  itemBuilder: (context, index) {
                    final cita = citas[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: const BoxDecoration(color: Color(0xFF1CB0F6), borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                          child: Row(children: [
                            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Text('Cita #${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                              child: Text(cita.estado, style: const TextStyle(color: Colors.white, fontSize: 11)),
                            ),
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(children: [
                            _buildRow(Icons.location_on_outlined, 'Oficina', cita.oficina),
                            const SizedBox(height: 8),
                            _buildRow(Icons.business_outlined, 'Area', cita.area),
                            const SizedBox(height: 8),
                            _buildRow(Icons.description_outlined, 'Motivo', cita.motivo),
                            const SizedBox(height: 8),
                            _buildRow(Icons.calendar_today, 'Fecha', cita.fecha),
                            const SizedBox(height: 8),
                            _buildRow(Icons.access_time, 'Hora', cita.hora),
                            const SizedBox(height: 8),
                            _buildRow(Icons.meeting_room_outlined, 'Sala', cita.sala),
                          ]),
                        ),
                      ]),
                    );
                  },
                ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/reserva-citas');
          setState(() {});
        },
        backgroundColor: const Color(0xFF1CB0F6),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nueva cita', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, color: const Color(0xFF1CB0F6), size: 16),
      const SizedBox(width: 8),
      Text('$label: ', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
    ]);
  }
}

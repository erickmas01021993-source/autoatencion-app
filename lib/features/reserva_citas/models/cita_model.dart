class CitaModel {
  final String oficina;
  final String area;
  final String motivo;
  final String fecha;
  final String hora;
  final String sala;
  final String estado;

  CitaModel({
    required this.oficina,
    required this.area,
    required this.motivo,
    required this.fecha,
    required this.hora,
    required this.sala,
    this.estado = 'Pendiente',
  });
}

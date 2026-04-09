import 'package:flutter/material.dart';
import '../models/cita_model.dart';

class CitasProvider extends ChangeNotifier {
  static final CitasProvider _instance = CitasProvider._internal();
  factory CitasProvider() => _instance;
  CitasProvider._internal();

  final List<CitaModel> _citas = [];
  List<CitaModel> get citas => List.unmodifiable(_citas);
  int get totalPendientes => _citas.where((c) => c.estado == 'Pendiente').length;

  void agregarCita(CitaModel cita) {
    _citas.add(cita);
    notifyListeners();
  }
}

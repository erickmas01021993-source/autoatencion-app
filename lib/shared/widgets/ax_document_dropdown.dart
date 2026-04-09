import 'package:flutter/material.dart';

class AxDocumentDropdown extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;

  static const List<String> documentTypes = ['DNI','CARNET DE EXTRANJERIA','RUC','PASAPORTE','RUT','CEDULA DE CIUDADANIA'];

  const AxDocumentDropdown({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1CB0F6), size: 22),
      style: const TextStyle(fontSize: 14, color: Color(0xFF333333), fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        filled: true, fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF1CB0F6), width: 1.5)),
      ),
      dropdownColor: Colors.white,
      items: documentTypes.map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 14)))).toList(),
    );
  }
}

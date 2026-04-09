import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autoatencion_app/shared/widgets/ax_auth_card.dart';
import 'package:autoatencion_app/shared/widgets/ax_button.dart';
import 'package:autoatencion_app/shared/widgets/ax_document_dropdown.dart';
import 'package:autoatencion_app/shared/widgets/ax_fonbienes_logo.dart';
import 'package:autoatencion_app/shared/widgets/ax_text_field.dart';

class RecoverPasswordScreen extends StatefulWidget {
  const RecoverPasswordScreen({super.key});
  @override
  State<RecoverPasswordScreen> createState() => _RecoverPasswordScreenState();
}

class _RecoverPasswordScreenState extends State<RecoverPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedDocumentType = 'DNI';
  bool _isLoading = false;
  int _step = 0;

  @override
  void dispose() {
    _documentNumberController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _stepTitle => _step == 0 ? 'Recupera tu contrasena' : _step == 1 ? 'Verificar codigo' : 'Nueva contrasena';
  String get _stepSubtitle => _step == 0 ? 'Ingresar datos' : _step == 1 ? 'Ingresa el codigo enviado' : 'Escribe tu nueva contrasena';

  Future<void> _onSiguiente() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);
    if (_step < 2) {
      setState(() => _step++);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contrasena actualizada'), backgroundColor: Color(0xFF4CAF50)));
        Navigator.of(context).pop();
      }
    }
  }

  void _onRegresar() {
    if (_step > 0) setState(() => _step--);
    else Navigator.of(context).pop();
  }

  Widget _buildStepContent() {
    if (_step == 0) {
      return Column(children: [
        AxDocumentDropdown(value: _selectedDocumentType, onChanged: (v) { if (v != null) setState(() => _selectedDocumentType = v); }),
        const SizedBox(height: 12),
        AxTextField(hint: 'Numero de documento', prefixIcon: Icons.person_outline, controller: _documentNumberController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null),
      ]);
    } else if (_step == 1) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Se envio un codigo a tu correo.', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        const SizedBox(height: 12),
        AxTextField(hint: 'Codigo de verificacion', prefixIcon: Icons.lock_outline, controller: _codeController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null),
      ]);
    } else {
      return Column(children: [
        AxTextField(hint: 'Nueva contrasena', prefixIcon: Icons.lock_outline, obscureText: true, controller: _newPasswordController, validator: (v) { if (v == null || v.isEmpty) return 'Campo requerido'; if (v.length < 6) return 'Minimo 6 caracteres'; return null; }),
        const SizedBox(height: 12),
        AxTextField(hint: 'Confirmar contrasena', prefixIcon: Icons.lock_outline, obscureText: true, controller: _confirmPasswordController, validator: (v) { if (v == null || v.isEmpty) return 'Campo requerido'; if (v != _newPasswordController.text) return 'No coinciden'; return null; }),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: AxAuthCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AxFonbienesLogo(),
                    const SizedBox(height: 20),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _step ? 28 : 10, height: 10,
                      decoration: BoxDecoration(
                        color: i < _step ? const Color(0xFF4CAF50) : i == _step ? const Color(0xFF1CB0F6) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ))),
                    const SizedBox(height: 20),
                    Text(_stepTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(_stepSubtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: KeyedSubtree(key: ValueKey(_step), child: _buildStepContent()),
                    ),
                    const SizedBox(height: 24),
                    Row(children: [
                      Expanded(child: AxButton(label: _step == 2 ? 'Finalizar' : 'Siguiente', icon: Icons.arrow_forward_ios_rounded, variant: AxButtonVariant.secondary, isLoading: _isLoading, onPressed: _onSiguiente)),
                      const SizedBox(width: 12),
                      Expanded(child: AxButton(label: 'Regresar', icon: Icons.arrow_back_ios_rounded, onPressed: _isLoading ? null : _onRegresar)),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:autoatencion_app/shared/widgets/ax_auth_card.dart';
import 'package:autoatencion_app/shared/widgets/ax_button.dart';
import 'package:autoatencion_app/shared/widgets/ax_document_dropdown.dart';
import 'package:autoatencion_app/shared/widgets/ax_fonbienes_logo.dart';
import 'package:autoatencion_app/shared/widgets/ax_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _documentNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedDocumentType = 'DNI';
  bool _isLoading = false;
  bool _showPasswordField = false;

  @override
  void dispose() {
    _documentNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSiguiente() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_showPasswordField) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() { _isLoading = false; _showPasswordField = true; });
    } else {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _onCambiarDocumento() {
    setState(() { _showPasswordField = false; _documentNumberController.clear(); _passwordController.clear(); });
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
                    const SizedBox(height: 24),
                    const Text('Acceso al Sistema', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text('Ingresar datos', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                    const SizedBox(height: 24),
                    AxDocumentDropdown(value: _selectedDocumentType, onChanged: (v) { if (v != null) setState(() => _selectedDocumentType = v); }),
                    const SizedBox(height: 12),
                    AxTextField(hint: 'Numero de documento', prefixIcon: Icons.person_outline, controller: _documentNumberController, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: _showPasswordField
                          ? Padding(padding: const EdgeInsets.only(top: 12), child: AxTextField(hint: 'Contrasena', prefixIcon: Icons.lock_outline, obscureText: true, controller: _passwordController, validator: (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null))
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(width: double.infinity, child: AxButton(label: _showPasswordField ? 'Ingresar' : 'Siguiente', icon: Icons.arrow_forward_ios_rounded, isLoading: _isLoading, onPressed: _onSiguiente)),
                    const SizedBox(height: 12),
                    if (_showPasswordField) ...[
                      SizedBox(width: double.infinity, child: AxButton(label: 'Cambiar Documento', icon: Icons.swap_horiz_rounded, variant: AxButtonVariant.secondary, onPressed: _onCambiarDocumento)),
                      const SizedBox(height: 12),
                    ],
                    TextButton(onPressed: () => Navigator.of(context).pushNamed('/recover-password'), child: const Text('Has olvidado tu contrasena?', style: TextStyle(color: Color(0xFF1CB0F6), fontSize: 13))),
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

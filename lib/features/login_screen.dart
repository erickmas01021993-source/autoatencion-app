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

  // Step 1: solo se muestra tipo + número de documento
  // Step 2: aparece el campo de contraseña tras validar el documento
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
      // Validar documento → mostrar campo contraseña
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 800)); // simula API
      setState(() {
        _isLoading = false;
        _showPasswordField = true;
      });
    } else {
      // Login final
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _isLoading = false);

      // TODO: navegar al home
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autenticando...')),
        );
      }
    }
  }

  void _onCambiarDocumento() {
    setState(() {
      _showPasswordField = false;
      _documentNumberController.clear();
      _passwordController.clear();
    });
  }

  void _onOlvidoContrasena() {
    Navigator.of(context).pushNamed('/recover-password');
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
                    // Logo
                    const AxFonbienesLogo(),
                    const SizedBox(height: 24),

                    // Título
                    const Text(
                      'Acceso al Sistema',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingresar datos',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Dropdown tipo de documento
                    AxDocumentDropdown(
                      value: _selectedDocumentType,
                      onChanged: (v) {
                        if (v != null) {
                          setState(() => _selectedDocumentType = v);
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    // Número de documento
                    AxTextField(
                      hint: 'Número de documento',
                      prefixIcon: Icons.person_outline,
                      controller: _documentNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Campo requerido' : null,
                    ),

                    // Contraseña (aparece tras validar documento)
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: _showPasswordField
                          ? Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: AxTextField(
                                hint: 'Contraseña',
                                prefixIcon: Icons.lock_outline,
                                obscureText: true,
                                controller: _passwordController,
                                validator: (v) => (v == null || v.isEmpty)
                                    ? 'Campo requerido'
                                    : null,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 20),

                    // Botón Ingresar / Siguiente
                    SizedBox(
                      width: double.infinity,
                      child: AxButton(
                        label: _showPasswordField ? 'Ingresar' : 'Siguiente',
                        icon: Icons.arrow_forward_ios_rounded,
                        isLoading: _isLoading,
                        onPressed: _onSiguiente,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Botón Cambiar documento (visible tras paso 1)
                    if (_showPasswordField) ...[
                      SizedBox(
                        width: double.infinity,
                        child: AxButton(
                          label: 'Cambiar Documento',
                          icon: Icons.swap_horiz_rounded,
                          variant: AxButtonVariant.secondary,
                          onPressed: _onCambiarDocumento,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    // Links
                    TextButton(
                      onPressed: _onOlvidoContrasena,
                      child: const Text(
                        '¿Has olvidado tu contraseña?',
                        style: TextStyle(
                          color: Color(0xFF1CB0F6),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: abrir videotutorial
                      },
                      child: const Text(
                        'Ver video tutorial',
                        style: TextStyle(
                          color: Color(0xFF1CB0F6),
                          fontSize: 13,
                        ),
                      ),
                    ),
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
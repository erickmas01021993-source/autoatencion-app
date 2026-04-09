import 'package:flutter/material.dart';
import 'package:autoatencion_app/features/auth/screens/login_screen.dart';
import 'package:autoatencion_app/features/auth/screens/recover_password_screen.dart';
import 'package:autoatencion_app/features/home/screens/home_screen.dart';
import 'package:autoatencion_app/features/reserva_citas/screens/reserva_citas_screen.dart';
import 'package:autoatencion_app/features/reserva_citas/screens/listado_citas_screen.dart';

void main() {
  runApp(const AutoAtencionApp());
}

class AutoAtencionApp extends StatelessWidget {
  const AutoAtencionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fonbienes AutoAtencion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/recover-password': (context) => const RecoverPasswordScreen(),
        '/home': (context) => const HomeScreen(),
        '/reserva-citas': (context) => const ReservaCitasScreen(),
        '/listado-citas': (context) => const ListadoCitasScreen(),
      },
    );
  }
}

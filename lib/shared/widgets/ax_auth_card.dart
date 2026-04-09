import 'package:flutter/material.dart';

class AxAuthCard extends StatelessWidget {
  final Widget child;
  const AxAuthCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 6))],
      ),
      child: child,
    );
  }
}

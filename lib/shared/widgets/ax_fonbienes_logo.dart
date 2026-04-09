import 'package:flutter/material.dart';

class AxFonbienesLogo extends StatelessWidget {
  final double height;
  const AxFonbienesLogo({super.key, this.height = 64});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180, height: 5,
          decoration: BoxDecoration(color: const Color(0xFF4CAF50), borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(height: 4),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(text: 'Fon', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF003087))),
              TextSpan(text: 'bienes', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Color(0xFF1CB0F6))),
            ],
          ),
        ),
        const Text('Peru EAFC S.A.', style: TextStyle(fontSize: 11, color: Color(0xFF003087), letterSpacing: 0.5, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

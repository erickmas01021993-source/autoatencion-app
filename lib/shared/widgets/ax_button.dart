import 'package:flutter/material.dart';

enum AxButtonVariant { primary, secondary }

class AxButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AxButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AxButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AxButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == AxButtonVariant.primary;
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF1CB0F6) : const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: isLoading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  if (icon != null) ...[const SizedBox(width: 8), Icon(icon, size: 18)],
                ],
              ),
      ),
    );
  }
}

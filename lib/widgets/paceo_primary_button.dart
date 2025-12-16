import 'package:flutter/material.dart';

class PaceoPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;

  const PaceoPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: GestureDetector(
        onTap: enabled ? onPressed : null,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: enabled
                ? const LinearGradient(
                    colors: [
                      Color(0xFFFF3B2F),
                      Color(0xFFB00020),
                    ],
                  )
                : const LinearGradient(
                    colors: [
                      Color(0xFFD3D3D3),
                      Color(0xFFB0B0B0),
                    ],
                  ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                offset: Offset(0, 4),
                color: Colors.black26,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

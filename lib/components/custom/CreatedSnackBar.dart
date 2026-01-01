import 'package:flutter/material.dart';

void showCreatedSnackBar(BuildContext context, String text) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    width: null, // 👈 allows wrap-content width
    backgroundColor: isDark ? const Color(0xFF334155) : Colors.white,
    elevation: isDark ? 0 : 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
      side: isDark
          ? const BorderSide(color: Color(0xFF10b981), width: 1.5)
          : BorderSide.none,
    ),
    content: Row(
      mainAxisSize: MainAxisSize.min, // 👈 shrink to content
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF065f46)
                : const Color(0xFFE6F4EA),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(6),
          child: Icon(
            Icons.check_circle_outline,
            color: isDark ? const Color(0xFF34d399) : const Color(0xFF10b981),
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
    duration: const Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
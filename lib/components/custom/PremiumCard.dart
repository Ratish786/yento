import 'package:flutter/material.dart';

class Premiumcard extends StatelessWidget {
  const Premiumcard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 150,
      child: Card(
        color: isDark ? const Color(0xff1e3a8a) : const Color(0xffbfdbfe),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: isDark ? 0 : 2,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_border,
                color: isDark ? const Color(0xff60a5fa) : const Color(0xff3b82f6),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                'Unlock Venne+',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xff1e40af),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Get advanced AI, group trips, video\ncalls, and more!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? const Color(0xff93c5fd) : const Color(0xff2563eb),
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Open premium modal or navigate to subscription
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3b82f6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Upgrade',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
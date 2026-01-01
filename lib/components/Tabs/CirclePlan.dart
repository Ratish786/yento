import 'package:flutter/material.dart';
import 'package:yento_app/components/dialog/CreatePlan.dart';

class Circleplan extends StatelessWidget {
  const Circleplan({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          // Share New Plan Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CreatePlanDialog(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: isDark
                      ? const Color(0xff1e3a8a)
                      : const Color(0xffeff6ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: isDark
                          ? const Color(0xff60a5fa)
                          : const Color(0xff1d4ed8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Share a New Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark
                            ? const Color(0xff93c5fd)
                            : const Color(0xff1d4ed8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Plan List Item
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF475569) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: isDark
                  ? Border.all(color: Colors.grey[700]!, width: 1)
                  : null,
              boxShadow: isDark
                  ? null
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xff1e3a8a)
                      : const Color(0xffdbeafe),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.event_outlined,
                  color: isDark
                      ? const Color(0xff60a5fa)
                      : const Color(0xff3b82f6),
                  size: 20,
                ),
              ),
              title: Text(
                'Weekly Team Sync',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              subtitle: Text(
                '24/11/2025',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? Colors.grey[500] : Colors.grey[400],
              ),
              onTap: () {
                // Navigate to plan details
              },
            ),
          ),
        ],
      ),
    );
  }
}
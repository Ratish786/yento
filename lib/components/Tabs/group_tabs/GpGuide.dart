import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GPGuide extends StatefulWidget {
  const GPGuide({super.key});

  @override
  State<GPGuide> createState() => _GPGuideState();
}

class _GPGuideState extends State<GPGuide> {
  bool _showGuides = false;

  void _generateGuides() {
    setState(() {
      _showGuides = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _showGuides ? _AIGuides() : _noGuid(_generateGuides),
    );
  }
}

Widget _noGuid(VoidCallback onPressed) {
  final isDark = Get.isDarkMode;

  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.menu_book,
        size: 80,
        color: isDark ? Colors.grey[600] : Colors.grey[400],
      ),
      const SizedBox(height: 20),
      Text(
        'No Guide generated yet.',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: 220,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFF3B82F6),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Icon(Icons.star, color: Color(0xFFFDE047), size: 18),
              Text(
                'Generate AI Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _AIGuides() {
  final isDark = Get.isDarkMode;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: ListView.builder(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDark ? const Color(0xFF334155) : Colors.grey[200],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.book,
              size: 40,
              color: Color(0xFF3B82F6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guide Title',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Info Unavailable',
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
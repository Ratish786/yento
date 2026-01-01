import 'package:flutter/material.dart';

class Circlevault extends StatelessWidget {
  const Circlevault({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.image_outlined, size: 52, color: Colors.grey),
            Text('No media shared yet', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

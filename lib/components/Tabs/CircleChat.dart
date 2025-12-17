import 'package:flutter/material.dart';

class Circlechat extends StatelessWidget {
  final String name;

  const Circlechat({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --------------- CHAT CONTENT AREA ---------------
        Expanded(
          child: Center(
            child: Text(
              'Chat Screen',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),

        // --------------- DIVIDER ---------------
        Divider(height: 1, color: Colors.grey.shade300),

        // --------------- BOTTOM INPUT BAR ---------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.attach_file_rounded,
                  size: 22,
                  color: Colors.grey,
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bar_chart, size: 22, color: Colors.grey),
              ),

              // ---------- INPUT FIELD BOX ----------
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Message #$name",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                      Icon(
                        Icons.emoji_emotions_outlined,
                        size: 22,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),
            ],
          ),
        ),
      ],
    );
  }
}

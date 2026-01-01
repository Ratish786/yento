import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GPChats extends StatelessWidget {
  const GPChats({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final isDark = Get.isDarkMode;

    return Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              // TODO: Replace with chat bubbles
            ],
          ),
        ),

        // Input field
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isDark
                      ? const Color(0xFF334155)
                      : Colors.grey[200],
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.gif_outlined,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: isDark
                      ? const Color(0xFF334155)
                      : Colors.grey[200],
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.location_on_outlined,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    minLines: 1,
                    maxLines: 4,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: "Discuss plans...",
                      hintStyle: TextStyle(
                        color: isDark ? Colors.grey[500] : Colors.grey[600],
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF334155)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF475569)
                              : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF475569)
                              : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFF3B82F6),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF3B82F6),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      final text = messageController.text.trim();
                      if (text.isEmpty) return;

                      // TODO: Send message
                      messageController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
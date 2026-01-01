import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/theme_controller.dart';

class Hangoutscreen extends StatefulWidget {
  const Hangoutscreen({super.key});

  @override
  State<Hangoutscreen> createState() => _HangoutscreenState();
}

class _HangoutscreenState extends State<Hangoutscreen> {
  final ThemeController themeC = Get.find<ThemeController>();

  bool isMikeOn = true;
  bool isVideoOn = true;
  bool isLocked = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Obx(() {
      final isDark = themeC.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF0F172A)
            : const Color(0xFF1E293B),
        body: SafeArea(
          child: Stack(
            children: [
              // Top Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Circle Name',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFFFFFFFF)
                                  : Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Locked Indicator
                          if (!isLocked)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Locked',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Leave Button
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'Leave',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Content (Video Grid Area)
              Center(
                child: Text(
                  'Video Call Area',
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                    fontSize: 18,
                  ),
                ),
              ),

              // Bottom Control Bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF000000)
                        : const Color(0xFF0F172A),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Microphone Button
                      _buildControlButton(
                        icon: isMikeOn
                            ? Icons.mic_none
                            : Icons.mic_off_outlined,
                        isActive: isMikeOn,
                        onPressed: () {
                          setState(() {
                            isMikeOn = !isMikeOn;
                          });
                        },
                        label: isMikeOn ? 'Mute' : 'Unmute',
                      ),

                      const SizedBox(width: 16),

                      // Video Button
                      _buildControlButton(
                        icon: isVideoOn
                            ? Icons.videocam_outlined
                            : Icons.videocam_off_outlined,
                        isActive: isVideoOn,
                        onPressed: () {
                          setState(() {
                            isVideoOn = !isVideoOn;
                          });
                        },
                        label: isVideoOn ? 'Stop Video' : 'Start Video',
                      ),

                      const SizedBox(width: 16),

                      // Lock Button
                      _buildControlButton(
                        icon: isLocked
                            ? Icons.lock_open_outlined
                            : Icons.lock_outline,
                        isActive: isLocked,
                        onPressed: () {
                          setState(() {
                            isLocked = !isLocked;
                          });
                        },
                        label: isLocked ? 'Unlock' : 'Lock',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isActive
                ? []
                : [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            style: IconButton.styleFrom(
              backgroundColor: isActive
                  ? const Color(0xFFFFFFFF).withOpacity(0.2)
                  : const Color(0xFFEF4444),
              padding: const EdgeInsets.all(16),
            ),
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: const Color(0xFFFFFFFF),
            ),
            iconSize: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
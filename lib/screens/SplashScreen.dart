import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_screen.dart';
import 'password_screen.dart';
import '../controller/theme_controller.dart';
import '../controller/pass_controller.dart';
import '../controller/auth_controller.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final ThemeController themeC = Get.put(ThemeController());

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        await _checkPinAndNavigate();
      }
    });
  }

  Future<void> _checkPinAndNavigate() async {
    try {
      final authC = Get.find<AuthController>();
      
      if (authC.isLoggedIn) {
        final passC = Get.put(PassController());
        final hasPinSet = await passC.hasPinSet();
        
        if (hasPinSet) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LockScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SimpleLoginScreen()),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SimpleLoginScreen()),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SimpleLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () {
        final isDark = themeC.isDarkMode.value;
        final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xfff1f5ff);
        final textColor = isDark ? Colors.white : const Color(0xff000000);
        final subtextColor = isDark ? Colors.white70 : Colors.black54;
        final loaderColor = isDark ? const Color(0xFF60A5FA) : const Color(0xff2563eb);

        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // --- Logo ---
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xff60a5fa), Color(0xff2563eb)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'V',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // --- App Name ---
                Text(
                  "Venne",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 8),

                // --- Tagline ---
                Text(
                  "Your inner circle, in sync.",
                  style: TextStyle(
                    color: subtextColor,
                    fontSize: 16,
                  ),
                ),

                const Spacer(),

                // --- Loading Indicator ---
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: loaderColor,
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}
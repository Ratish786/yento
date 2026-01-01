import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:yento_app/controller/chat_controller.dart';
import 'package:yento_app/controller/circle_controller.dart';
import 'package:yento_app/controller/theme_controller.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import 'package:yento_app/screens/SplashScreen.dart';
import 'controller/auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GetStorage.init();
  
  // Initialize controllers in the correct order
  Get.put(ThemeController(), permanent: true);
  Get.put(SidebarController(), permanent: true);
  Get.put(ChatController(), permanent: true);
  Get.put(CircleController(), permanent: true);
  Get.put(AuthController(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yento Demo',
      theme: themeController.lightTheme,
      darkTheme: themeController.darkTheme,
      themeMode: ThemeMode.system,
      home: Splashscreen(),
    );
  }
}

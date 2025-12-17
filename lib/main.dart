import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/controller/chat_controller.dart';
import 'package:yento_app/controller/circle_controller.dart';
import 'package:yento_app/screens/login_screen.dart';
import 'components/custom/app_shell.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(ChatController(), permanent: true);
  Get.put(CircleController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yento Demo',
      home: SimpleLoginScreen(),
    );
  }
}

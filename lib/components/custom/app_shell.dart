import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yento_app/components/custom/customDrawer.dart';
import 'package:yento_app/controller/sidebar_controller.dart';
import 'package:yento_app/controller/theme_controller.dart';
import 'package:yento_app/screens/MomentsScreen.dart';
import 'package:yento_app/screens/ProfileScreen.dart';
import 'package:yento_app/screens/messagesScreen.dart';
import 'package:yento_app/components/dialog/CircleDetails.dart';
import '../../screens/broadcastScreen.dart';
import '../../screens/calenderScreen.dart';
import '../../screens/circleScreen.dart';
import '../../screens/findFriendsScreen.dart';
import '../../screens/groupPlansScreen.dart';
import '../../screens/homescreen.dart';

class AppShell extends StatefulWidget {
  static final GlobalKey<ScaffoldState> shellScaffoldKey = GlobalKey();

  AppShell({super.key});

  @override
  _AppShellState createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey();
  final ThemeController themeC = Get.put(ThemeController());
  String currentRoute = "/home";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final nav = _navKey.currentState;
        if (nav != null && nav.canPop()) {
          nav.pop();
        }
      },
      child: Obx(
            () => Scaffold(
          key: AppShell.shellScaffoldKey,
          backgroundColor: themeC.isDarkMode.value
              ? const Color(0xFF1A1B2E)
              : Colors.grey[200],
          drawer: CustomDrawer(
            onNavigate: (routeName) {
              Navigator.pop(context);
              if (routeName == "/home") {
                final nav = _navKey.currentState!;
                if (nav.canPop()) {
                  try {
                    nav.popUntil((route) => route.settings.name == "/home");
                  } catch (e) {
                    nav.pushNamedAndRemoveUntil("/home", (route) => false);
                  }
                } else {
                  nav.pushNamedAndRemoveUntil("/home", (route) => false);
                }
              } else {
                _navKey.currentState!.pushNamedAndRemoveUntil(
                  routeName,
                  ModalRoute.withName("/home"),
                );
              }
            },
          ),
          body: Navigator(
            key: _navKey,
            initialRoute: "/home",
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case "/home":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                    const HomeScreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/broadcast":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BroadcastScreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/calender":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CalenderScreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/circle":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Circlescreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/circleDetails":
                  final args = settings.arguments as Map<String, dynamic>?;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CircleDetailsScreen(name: args?['name'] ?? 'Circle'),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/findFriend":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Findfriendsscreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/group":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Groupplansscreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/moments":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondAnimation) =>
                        Momentsscreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/messages":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondAnimation) =>
                        Messagesscreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
                case "/profile":
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondAnimation) =>
                    const Profilescreen(),
                    settings: settings,
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}